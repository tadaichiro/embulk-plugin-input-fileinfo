# Embulk output plugin for file information

get file information(name, path, size so on)

## Configuration

- **rootdir** search root directory  (string, required)
- **extension** filter file extension (string, default: *(all))
- **sizelowerlimit** filter file size (integer, default: 0)

### Example

```yaml
in:
  type: fileinfo
  rootdir: '/etc'
  extension: 'txt'
  sizelowerlimit: 500
```