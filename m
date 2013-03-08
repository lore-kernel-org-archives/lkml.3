Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697Ab3CHP1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:27:52 -0500
Received: from mail.crc.id.au ([203.56.246.92]:60892 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab3CHP1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:27:51 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Mar 2013 10:27:50 EST
Message-ID: <513A01DD.7030108@crc.id.au>
Date: Sat, 09 Mar 2013 02:21:01 +1100
From: Steven Haigh <netwiz@crc.id.au>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel 3.8.x on EL6.3 systems.
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020100080002040401040004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms020100080002040401040004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi all,

Firstly, please CC me in replies. I'm not subscribed to this list.

Some of you might know I'm maintaining a Xen Dom0 kernel for EL6, and=20
I'm wondering if I can get some help of someone who knows udev a little=20
better than me...

I've updated my kernel to 3.8.2 now, and starting at 3.8.1 I start to=20
get this on boot when starting udev:
Starting udev:
udevadm settle - timeout of 180 seconds reached, the event queue contains=
:
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0103:00 (1493)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/IPI0001:00 =

(1534)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/PNP0000:00 =

(1535)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/PNP0003:00 =

(1536)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/PNP0100:00 =

(1537)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/PNP0200:00 =

(1538)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/PNP0501:00 =

(1539)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/PNP0800:00 =

(1540)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/PNP0B00:00 =

(1541)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/PNP0C02:00 =

(1542)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/PNP0C02:01 =

(1543)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:27/PNP0C04:00 =

(1544)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:0:0/0:0:0=
:0/scsi_device/0:0:0:0=20
(1584)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:0/0:1:0=
:0=20
(1587)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:0/0:1:0=
:0/bsg/0:1:0:0=20
(1588)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:0/0:1:0=
:0/scsi_device/0:1:0:0=20
(1589)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:1/0:1:1=
:0=20
(1591)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:1/0:1:1=
:0/bsg/0:1:1:0=20
(1592)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:1/0:1:1=
:0/scsi_device/0:1:1:0=20
(1593)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:2/0:1:2=
:0=20
(1595)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:2/0:1:2=
:0/bsg/0:1:2:0=20
(1596)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:2/0:1:2=
:0/scsi_device/0:1:2:0=20
(1597)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:3/0:1:3=
:0=20
(1599)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:3/0:1:3=
:0/bsg/0:1:3:0=20
(1600)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:3/0:1:3=
:0/scsi_device/0:1:3:0=20
(1601)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:4/0:1:4=
:0=20
(1603)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:4/0:1:4=
:0/bsg/0:1:4:0=20
(1604)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:4/0:1:4=
:0/scsi_device/0:1:4:0=20
(1605)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:5/0:1:5=
:0=20
(1607)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:5/0:1:5=
:0/bsg/0:1:5:0=20
(1608)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:5/0:1:5=
:0/scsi_device/0:1:5:0=20
(1609)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:6/0:1:6=
:0=20
(1611)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:6/0:1:6=
:0/bsg/0:1:6:0=20
(1612)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:6/0:1:6=
:0/scsi_device/0:1:6:0=20
(1613)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:7/0:1:7=
:0=20
(1615)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:7/0:1:7=
:0/bsg/0:1:7:0=20
(1616)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:7/0:1:7=
:0/scsi_device/0:1:7:0=20
(1617)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:3:0/0:3:0=
:0=20
(1619)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:3:0/0:3:0=
:0/bsg/0:3:0:0=20
(1620)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:3:0/0:3:0=
:0/scsi_device/0:3:0:0=20
(1621)
    /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/0000:03:00.0 (1642)=

    /sys/devices/pci0000:00/0000:00:1c.1/0000:05:00.0/0000:06:00.0 (1648)=

    /sys/devices/pci0000:00/0000:00:1e.0/0000:01:06.0 (1672)
    /sys/devices/pci0000:00/0000:00:1e.0/0000:01:06.0/drm/card0 (1673)
=20
/sys/devices/pci0000:00/0000:00:1f.2/ata2/host2/target2:0:0/2:0:0:0/scsi_=
device/2:0:0:0=20
(1690)
    /sys/devices/virtual/dmi/id (1880)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:0/0:1:0=
:0/scsi_generic/sg1=20
(1997)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:1/0:1:1=
:0/scsi_generic/sg2=20
(1998)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:2/0:1:2=
:0/scsi_generic/sg3=20
(1999)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:3/0:1:3=
:0/scsi_generic/sg4=20
(2000)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:4/0:1:4=
:0/scsi_generic/sg5=20
(2001)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:5/0:1:5=
:0/scsi_generic/sg6=20
(2002)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:6/0:1:6=
:0/scsi_generic/sg7=20
(2003)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:7/0:1:7=
:0/scsi_generic/sg8=20
(2004)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:3:0/0:3:0=
:0/scsi_generic/sg9=20
(2005)
=20
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:3:0/0:3:0=
:0/enclosure/0:3:0:0=20
(2010)
    /sys/devices/pci0000:00/0000:00:1f.0/iTCO_wdt (2051)
    /sys/devices/pci0000:00/0000:00:1f.0/gpio_ich (2052)
    /sys/devices/platform/pcspkr/input/input1 (2062)
    /sys/devices/platform/pcspkr/input/input1/event1 (2063)
    /sys/devices/platform/microcode (2066)
udevd[387]: worker [395] unexpectedly returned with status 0x0100
udevd[387]: worker [395] failed while handling=20
'/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:0/0:1:0:0'=

udevd[387]: worker [396] unexpectedly returned with status 0x0100
udevd[387]: worker [396] failed while handling=20
'/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:1/0:1:1:0'=

udevd[387]: worker [397] unexpectedly returned with status 0x0100
udevd[387]: worker [397] failed while handling=20
'/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:2/0:1:2:0'=

udevd[387]: worker [398] unexpectedly returned with status 0x0100
udevd[387]: worker [398] failed while handling=20
'/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:3/0:1:3:0'=

udevd[387]: worker [400] unexpectedly returned with status 0x0100
udevd[387]: worker [400] failed while handling=20
'/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:4/0:1:4:0'=

udevd[387]: worker [401] unexpectedly returned with status 0x0100
udevd[387]: worker [401] failed while handling=20
'/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:5/0:1:5:0'=

udevd[387]: worker [402] unexpectedly returned with status 0x0100
udevd[387]: worker [402] failed while handling=20
'/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:6/0:1:6:0'=

udevd[387]: worker [403] unexpectedly returned with status 0x0100
udevd[387]: worker [403] failed while handling=20
'/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:1:7/0:1:7:0'=

udevd[387]: worker [404] unexpectedly returned with status 0x0100
udevd[387]: worker [404] failed while handling=20
'/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host0/target0:3:0/0:3:0:0'=

udevd[387]: worker [485] unexpectedly returned with status 0x0100
udevd[387]: worker [485] failed while handling '/devices/virtual/dmi/id'


I haven't seen this before, and I don't really have a great depth of=20
knowledge on udev to start debugging this. I believe it certainly is=20
*something* to do with the kernel - as 3.7.x didn't do this.

For reference:
# lspci
00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller=20
Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 =

Port 2 (rev b1)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 =

Port 3 (rev b1)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 =

Port 4-5 (rev b1)
00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 =

Port 5 (rev b1)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 =

Port 6-7 (rev b1)
00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 =

Port 7 (rev b1)
00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA=20
Engine (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers =

(rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers =

(rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers =

(rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved=20
Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved=20
Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers =

(rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers =

(rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI=20
Express Root Port 1 (rev 09)
00:1c.1 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI=20
Express Root Port 2 (rev 09)
00:1d.0 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset=20
UHCI USB Controller #1 (rev 09)
00:1d.1 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset=20
UHCI USB Controller #2 (rev 09)
00:1d.2 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset=20
UHCI USB Controller #3 (rev 09)
00:1d.3 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset=20
UHCI USB Controller #4 (rev 09)
00:1d.7 USB controller: Intel Corporation 631xESB/632xESB/3100 Chipset=20
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC=20
Interface Controller (rev 09)
00:1f.2 IDE interface: Intel Corporation 631xESB/632xESB/3100 Chipset=20
SATA IDE Controller (rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus=20
Controller (rev 09)
01:06.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI=20
ES1000 (rev 02)
02:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
03:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708=20
Gigabit Ethernet (rev 12)
04:00.0 RAID bus controller: Adaptec AAC-RAID (Rocket) (rev 02)
05:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
06:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708=20
Gigabit Ethernet (rev 12)
1a:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express=20
Upstream Port (rev 01)
1a:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to=20
PCI-X Bridge (rev 01)
1b:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express=20
Downstream Port E1 (rev 01)
1b:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express=20
Downstream Port E2 (rev 01)

Any thoughts on this?

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299



--------------ms020100080002040401040004
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMdTCC
BjQwggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDE1NVoXDTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOr
lr6KMoOMpohBllVHrdRvEg/q6r8jR+EK75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSM
zR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6
qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxDz2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSD
kOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr/+N2JLKutIxMYqQOJebr/f/h5t95
m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFcfH6WNU7y1LhRgjAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqD
CH14qywGXLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy
6QMVQjbbMXltUfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPI
zKKR9tQW8gGK+2+RHxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKf
KSETEPrHh7p5shuuNktvsv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HOR
z9v3vQwR4e3ksLc2JZOAFK+ssS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9
sIPP7ON0fz095HdThKjiVJe6vofq+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCie
uoBJ9OlqmsVWQvifIYf40dJPZkk9YgGTzWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7t
w1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGqUp/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQ
G2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb19mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t
5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIGOTCCBSGgAwIBAgIDBdMXMA0GCSqGSIb3DQEB
BQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMi
U2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20g
Q2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcNMTMwMTI5MTIyMTM0
WhcNMTQwMTMwMjIzNjE4WjBXMRkwFwYDVQQNExA0MzM5TjFVWjZFS2ZBa0Y2MRkwFwYDVQQD
DBBuZXR3aXpAY3JjLmlkLmF1MR8wHQYJKoZIhvcNAQkBFhBuZXR3aXpAY3JjLmlkLmF1MIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqz7eWA7Oi1ES6IIWwtRNtOa6cSj6GSio
72D26TkCPm/vYamqS/9pluIyMO2TbGjMyveGxWZB9bDt+MnuI6yJ3spD6br5TUXQSqsgp1/g
NXicgNmUHESd/A7+POEdYKMyTtXjVEqmR8R6uPtD78MBhIKQVZdBYGFuRBhrjoFMOnWARmXD
47FG6eLH8jyeBi+RGEYEpBgTe1gFcoU1dCrjBqxAj47ALNgcHP4ffNX47DLvyhW2pMMaOYUh
ga/UyQuPOpZcMAJdVI7dTIkbdipboEEE5pTdoIRI+F+XDLzO8bNkGLa1xLTWrbP048xxw3SL
Aw/DmLYqQ+oC8vabAAqBIwIDAQABo4IC1jCCAtIwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAw
HQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBR/FxImYCufSdz0pG5w
A8VPzNyaujAfBgNVHSMEGDAWgBRTcu2SnODaywFcfH6WNU7y1LhRgjAbBgNVHREEFDASgRBu
ZXR3aXpAY3JjLmlkLmF1MIIBTAYDVR0gBIIBQzCCAT8wggE7BgsrBgEEAYG1NwECAzCCASow
LgYIKwYBBQUHAgEWImh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwgfcGCCsG
AQUFBwICMIHqMCcWIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5U
aGlzIGNlcnRpZmljYXRlIHdhcyBpc3N1ZWQgYWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAxIFZh
bGlkYXRpb24gcmVxdWlyZW1lbnRzIG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3ksIHJlbGlh
bmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBwdXJwb3NlIGluIGNvbXBsaWFuY2Ugb2YgdGhl
IHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9j
cmwuc3RhcnRzc2wuY29tL2NydHUxLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYB
BQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xhc3MxL2NsaWVudC9jYTBC
BggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNzMS5j
bGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkq
hkiG9w0BAQUFAAOCAQEAwsdSJioQIH5mEXlMBkQBZN9qrqCvDn4e92NKIX2LMPhVH01o0weH
MEgkFMOBypbcPrwnZD51IL+ZfPmuDrcFJR9SPk4W95p3wLakMUBmvDPJ3IC+pa97+fU/GYsh
q4dth+VlAIWJarpPV5ee6hAXGQEZvC2jyy5ukcjlr/oQxegb4hufgkLhKjqaq5UDs2be5q1N
CBewezVmAbb/VDNVogP1xacnHn4rhllskMfGAda2DPCCaSMaJ3LcC5JRyfMkpKe5UxpVmVeM
vGP8hYGI9DlFjwpqRCmIvD/Wl6oWWJc0HaLl6k+U3dngqEHhunzh3H6b/3lWOmEKQuI3Piy+
oDGCA90wggPZAgEBMIGUMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRk
LjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UE
AxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAwXT
FzAJBgUrDgMCGgUAoIICHTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0xMzAzMDgxNTIxMDFaMCMGCSqGSIb3DQEJBDEWBBRB8MsVxo128CakLr6WQjjq520W
wzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcN
AwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMC
AgEoMIGlBgkrBgEEAYI3EAQxgZcwgZQwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFy
dENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5n
MTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVu
dCBDQQIDBdMXMIGnBgsqhkiG9w0BCRACCzGBl6CBlDCBjDELMAkGA1UEBhMCSUwxFjAUBgNV
BAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRl
IFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlh
dGUgQ2xpZW50IENBAgMF0xcwDQYJKoZIhvcNAQEBBQAEggEAdHqm2dmQDU5z7GJf5bEfx2IF
SJa0kmpB0DmEQdxcO/T4EsnLtjGChZmZzDEyHVOkKlwbusBYq3rIsuq/A5jQg6mPCvmlFFYO
c0OAkUurJxiyHrcCNhOturyUVSfUH+v42MTHysapVpuyy53WkdzMaYmKAz0Zq4I4xJc9lM/6
+hWdnaipki8ZJCXNis7WESov43TRAq3fPM8QSfPIAsBlOh7Yhe/k0ekcfElKI8b1U2V5ryJB
4ZqrTg2KU5A1Z3HeHjl5t4AtJYnA4pJovyjsaa1nxQKohingN7zs0u1TlTMUflDFcuE4K9LX
HYzaW/P7k5Ns2pEZ3qQGui9dZaf0wgAAAAAAAA==
--------------ms020100080002040401040004--
