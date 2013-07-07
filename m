Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3GGScK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 14:32:10 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34084 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3GGScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 14:32:04 -0400
Date: Sun, 7 Jul 2013 11:31:58 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soeren.brinkmann@gmail.com>
To: Tomas Winkler <tomas.winkler@intel.com>, Shuah Khan <shuah.kh@samsung.com>
Cc: =?utf-8?B?U8O2cmVu?= Brinkmann <soeren.brinkmann@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: Linux 3.10-rc7
Message-ID: <20130707183158.GA2090@skorgonTP.att.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <CA+i0qc7p=y0Y1xBk4CVAC47sr09rmaWdtwt2bw8KNFDSpsYYqA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

since I updated to 3.10 my system freezes occasionally. Googling the
messages in my kernel log (attached) make me suspect, that my problem
might be related to the issue Shuah reported.

So, I just wanted to check in, what the status of this issue is.

In case it helps: I'm on a amd64, 64-bit Arch Linux system running
kernel 3.10 (vanilla). My machine is a Lenovo T510.

I had to copy the recipient list for this email from some LKML archive
on the web, apologies if it is not complete.

	Thanks,
	S=C3=B6ren

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="bug.log"
Content-Transfer-Encoding: quoted-printable

Jul 07 00:32:11 hostname kernel: wlp3s0: deauthenticating from 1c:14:48:5f:=
1a:20 by local choice (reason=3D3)
Jul 07 00:32:11 hostname kernel: cfg80211: All devices are disconnected, go=
ing to restore regulatory settings
Jul 07 00:32:11 hostname kernel: cfg80211: Restoring regulatory settings
Jul 07 00:32:11 hostname kernel: cfg80211: Kicking the queue
Jul 07 00:32:12 hostname kernel: cfg80211: Calling CRDA to update world reg=
ulatory domain
Jul 07 00:32:16 hostname kernel: PM: Syncing filesystems ... done.
Jul 07 09:39:28 hostname kernel: Freezing user space processes ... (elapsed=
 0.07 seconds) done.
Jul 07 09:39:28 hostname kernel: Freezing remaining freezable tasks ... (el=
apsed 0.01 seconds) done.
Jul 07 09:39:28 hostname kernel: Suspending console(s) (use no_console_susp=
end to debug)
Jul 07 09:39:28 hostname kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
Jul 07 09:39:28 hostname kernel: sd 0:0:0:0: [sda] Stopping disk
Jul 07 09:39:28 hostname kernel: nouveau  [     DRM] suspending fbcon...
Jul 07 09:39:28 hostname kernel: nouveau  [     DRM] suspending display...
Jul 07 09:39:28 hostname kernel: nouveau  [     DRM] unpinning framebuffer(=
s)...
Jul 07 09:39:28 hostname kernel: nouveau  [     DRM] evicting buffers...
Jul 07 09:39:28 hostname kernel: mei_me 0000:00:16.0: suspend
Jul 07 09:39:29 hostname kernel: nouveau  [     DRM] waiting for kernel cha=
nnels to go idle...
Jul 07 09:39:30 hostname kernel: nouveau  [     DRM] suspending client obje=
ct trees...
Jul 07 09:39:30 hostname kernel: nouveau  [     DRM] suspending kernel obje=
ct tree...
Jul 07 09:39:30 hostname kernel: nouveau 0000:01:00.0: power state changed =
by ACPI to D3hot
Jul 07 09:39:30 hostname kernel: PM: suspend of devices complete after 4960=
=2E340 msecs
Jul 07 09:39:30 hostname kernel: PM: late suspend of devices complete after=
 0.223 msecs
Jul 07 09:39:30 hostname kernel: ehci-pci 0000:00:1d.0: System wakeup enabl=
ed by ACPI
Jul 07 09:39:30 hostname kernel: ehci-pci 0000:00:1d.0: power state changed=
 by ACPI to D3hot
Jul 07 09:39:30 hostname kernel: ehci-pci 0000:00:1a.0: System wakeup enabl=
ed by ACPI
Jul 07 09:39:30 hostname kernel: ehci-pci 0000:00:1a.0: power state changed=
 by ACPI to D3hot
Jul 07 09:39:30 hostname kernel: e1000e 0000:00:19.0: System wakeup enabled=
 by ACPI
Jul 07 09:39:30 hostname kernel: PM: noirq suspend of devices complete afte=
r 79.700 msecs
Jul 07 09:39:30 hostname kernel: ACPI: Preparing to enter system sleep stat=
e S3
Jul 07 09:39:30 hostname kernel: PM: Saving platform NVS memory
Jul 07 09:39:30 hostname kernel: Disabling non-boot CPUs ...
Jul 07 09:39:30 hostname kernel: smpboot: CPU 1 is now offline
Jul 07 09:39:30 hostname kernel: smpboot: CPU 2 is now offline
Jul 07 09:39:30 hostname kernel: smpboot: CPU 3 is now offline
Jul 07 09:39:30 hostname kernel: ACPI: Low-level resume complete
Jul 07 09:39:30 hostname kernel: PM: Restoring platform NVS memory
Jul 07 09:39:30 hostname kernel: Enabling non-boot CPUs ...
Jul 07 09:39:30 hostname kernel: smpboot: Booting Node 0 Processor 1 APIC 0=
x1
Jul 07 09:39:30 hostname kernel: CPU1 is up
Jul 07 09:39:30 hostname kernel: smpboot: Booting Node 0 Processor 2 APIC 0=
x4
Jul 07 09:39:30 hostname kernel: CPU2 is up
Jul 07 09:39:30 hostname kernel: smpboot: Booting Node 0 Processor 3 APIC 0=
x5
Jul 07 09:39:30 hostname kernel: CPU3 is up
Jul 07 09:39:30 hostname kernel: ACPI: Waking up from system sleep state S3
Jul 07 09:39:30 hostname kernel: ehci-pci 0000:00:1a.0: power state changed=
 by ACPI to D0
Jul 07 09:39:30 hostname kernel: ehci-pci 0000:00:1a.0: System wakeup disab=
led by ACPI
Jul 07 09:39:30 hostname kernel: ehci-pci 0000:00:1d.0: power state changed=
 by ACPI to D0
Jul 07 09:39:30 hostname kernel: ehci-pci 0000:00:1d.0: System wakeup disab=
led by ACPI
Jul 07 09:39:30 hostname kernel: nouveau 0000:01:00.0: power state changed =
by ACPI to D0
Jul 07 09:39:30 hostname kernel: sdhci-pci 0000:0d:00.0: MMC controller bas=
e frequency changed to 50Mhz.
Jul 07 09:39:30 hostname kernel: PM: noirq resume of devices complete after=
 173.837 msecs
Jul 07 09:39:30 hostname kernel: PM: early resume of devices complete after=
 0.104 msecs
Jul 07 09:39:30 hostname kernel: e1000e 0000:00:19.0: System wakeup disable=
d by ACPI
Jul 07 09:39:30 hostname kernel: e1000e 0000:00:19.0: setting latency timer=
 to 64
Jul 07 09:39:30 hostname kernel: mei_me 0000:00:16.0: irq 41 for MSI/MSI-X
Jul 07 09:39:30 hostname kernel: e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
Jul 07 09:39:30 hostname kernel: ehci-pci 0000:00:1a.0: setting latency tim=
er to 64
Jul 07 09:39:30 hostname kernel: pci 0000:00:1e.0: setting latency timer to=
 64
Jul 07 09:39:30 hostname kernel: ahci 0000:00:1f.2: setting latency timer t=
o 64
Jul 07 09:39:30 hostname kernel: snd_hda_intel 0000:00:1b.0: irq 45 for MSI=
/MSI-X
Jul 07 09:39:30 hostname kernel: ehci-pci 0000:00:1d.0: setting latency tim=
er to 64
Jul 07 09:39:30 hostname kernel: nouveau  [     DRM] re-enabling device...
Jul 07 09:39:30 hostname kernel: nouveau  [     DRM] resuming kernel object=
 tree...
Jul 07 09:39:30 hostname kernel: nouveau  [   VBIOS][0000:01:00.0] running =
init tables
Jul 07 09:39:30 hostname kernel: mei_me 0000:00:16.0: wait hw ready failed.=
 status =3D 0x0
Jul 07 09:39:30 hostname kernel: mei_me 0000:00:16.0: version message write=
t failed
Jul 07 09:39:30 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:30 hostname kernel: mei_me 0000:00:16.0: wait hw ready failed.=
 status =3D 0x0
Jul 07 09:39:30 hostname kernel: tpm_tis 00:09: TPM is disabled/deactivated=
 (0x6)
Jul 07 09:39:30 hostname kernel: usb 1-1.6: reset high-speed USB device num=
ber 4 using ehci-pci
Jul 07 09:39:30 hostname kernel: nouveau  [     DRM] resuming client object=
 trees...
Jul 07 09:39:30 hostname kernel: nouveau  [     DRM] resuming display...
Jul 07 09:39:30 hostname kernel: ata5: SATA link down (SStatus 0 SControl 3=
00)
Jul 07 09:39:30 hostname kernel: ata6: SATA link down (SStatus 0 SControl 3=
00)
Jul 07 09:39:30 hostname kernel: usb 1-1.4: reset full-speed USB device num=
ber 3 using ehci-pci
Jul 07 09:39:30 hostname kernel: btusb 1-1.4:1.0: no reset_resume for drive=
r btusb?
Jul 07 09:39:30 hostname kernel: btusb 1-1.4:1.1: no reset_resume for drive=
r btusb?
Jul 07 09:39:30 hostname kernel: sdhci-pci 0000:0d:00.0: Will use DMA mode =
even though HW doesn't fully claim to support it.
Jul 07 09:39:30 hostname kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 S=
Control 300)
Jul 07 09:39:30 hostname kernel: ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (ID=
LE) succeeded
Jul 07 09:39:30 hostname kernel: ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (ID=
LE) succeeded
Jul 07 09:39:30 hostname kernel: ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (ID=
LE) succeeded
Jul 07 09:39:30 hostname kernel: ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (ID=
LE) succeeded
Jul 07 09:39:30 hostname kernel: ata2.00: configured for UDMA/66
Jul 07 09:39:30 hostname kernel: usb 2-1.4: reset high-speed USB device num=
ber 3 using ehci-pci
Jul 07 09:39:30 hostname kernel: firewire_core 0000:0d:00.3: rediscovered d=
evice fw0
Jul 07 09:39:30 hostname kernel: qcserial 2-1.4:1.1: no reset_resume for dr=
iver qcserial?
Jul 07 09:39:30 hostname kernel: qcserial ttyUSB0: Qualcomm USB modem conve=
rter now disconnected from ttyUSB0
Jul 07 09:39:30 hostname kernel: qcserial 2-1.4:1.1: device disconnected
Jul 07 09:39:30 hostname kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 S=
Control 300)
Jul 07 09:39:30 hostname kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SE=
T FEATURES) succeeded
Jul 07 09:39:30 hostname kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SE=
CURITY FREEZE LOCK) filtered out
Jul 07 09:39:30 hostname kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SE=
T FEATURES) filtered out
Jul 07 09:39:30 hostname kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SE=
T FEATURES) succeeded
Jul 07 09:39:30 hostname kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SE=
CURITY FREEZE LOCK) filtered out
Jul 07 09:39:30 hostname kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SE=
T FEATURES) filtered out
Jul 07 09:39:30 hostname kernel: ata1.00: configured for UDMA/100
Jul 07 09:39:30 hostname kernel: sd 0:0:0:0: [sda] Starting disk
Jul 07 09:39:30 hostname kernel: PM: resume of devices complete after 2729.=
549 msecs
Jul 07 09:39:30 hostname kernel: qcserial 2-1.4:1.1: Qualcomm USB modem con=
verter detected
Jul 07 09:39:30 hostname kernel: usb 2-1.4: Qualcomm USB modem converter no=
w attached to ttyUSB0
Jul 07 09:39:30 hostname kernel: Restarting tasks ... done.
Jul 07 09:39:30 hostname kernel: video LNXVIDEO:01: Restoring backlight sta=
te
Jul 07 09:39:31 hostname kernel: e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
Jul 07 09:39:31 hostname kernel: e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
Jul 07 09:39:31 hostname kernel: IPv6: ADDRCONF(NETDEV_UP): enp0s25: link i=
s not ready
Jul 07 09:39:31 hostname kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disablin=
g L0S
Jul 07 09:39:31 hostname kernel: iwlwifi 0000:03:00.0: Radio type=3D0x0-0x3=
-0x1
Jul 07 09:39:31 hostname kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is=
 not ready
Jul 07 09:39:38 hostname kernel: wlp3s0: authenticate with 1c:14:48:5f:1a:20
Jul 07 09:39:38 hostname kernel: wlp3s0: send auth to 1c:14:48:5f:1a:20 (tr=
y 1/3)
Jul 07 09:39:38 hostname kernel: wlp3s0: authenticated
Jul 07 09:39:38 hostname kernel: wlp3s0: associate with 1c:14:48:5f:1a:20 (=
try 1/3)
Jul 07 09:39:38 hostname kernel: wlp3s0: RX AssocResp from 1c:14:48:5f:1a:2=
0 (capab=3D0x411 status=3D0 aid=3D7)
Jul 07 09:39:38 hostname kernel: wlp3s0: associated
Jul 07 09:39:38 hostname kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: lin=
k becomes ready
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: init clients t=
imeout hbm_state =3D 1.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: we can't read the mes=
sage slots =3D00000008.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: wrong host sta=
rt response
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: unexpected reset: dev=
_state =3D RESETTING
Jul 07 09:39:54 hostname kernel: mei_me 0000:00:16.0: reset: unexpected enu=
meration response hbm.
=1B[1;39m-- Reboot --=1B[0m

--lrZ03NoBR/3+SXJZ--

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAEBAgAGBQJR2bQeAAoJEE3EUu+tZnRfAbkH/RWpUaagZJF02n2Xfg6ItF/S
zlVT8Xp0N6NldGZcBXqTJ73XBcO3lrDa/1fC7y3o2tyboBS0MA7/QgmNU3WUUY7H
RzRE7JutZ7Fz+s4OPRMfYJoD6DunI/wP7JLTKNTdAhr2e50JWXMJKbIirepdAN3k
sMlyhirKjcsmif0QnRi4LUUDbOfPH3STiT9ZOQmpnNbe3wGyM39SNHh6Q/yWBn+M
x3TtxnuKQYfBT2HHccsAAdUD2NzOEd4YSIqr0Vvn4sTqDUc+yZfEtic0U2JLeG21
fCj2BAfNijm8Bca+cWZZT3jcS81kZs5yIDLyUJ/mrzFEwHWq5LoCAxYJFghlZVY=
=eKWL
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
