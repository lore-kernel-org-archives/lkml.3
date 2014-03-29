Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaC2THk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 15:07:40 -0400
Received: from libra.uberspace.de ([95.143.172.171]:46663 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752080AbaC2THj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 15:07:39 -0400
Date: Sat, 29 Mar 2014 20:05:46 +0100
From: Matthias Beyer <mail@beyermatthias.de>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 3.14-rc6 at mousedev_open_device+0x77/0x100
Message-ID: <20140329190546.GE4617@fu.192.168.200.1>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1513450.PT1cqDJBLI@grover>
 <20140329111535.GA4275@fu.192.168.200.1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Content-Disposition: inline
In-Reply-To: <20140329111535.GA4275@fu.192.168.200.1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I want to add that my suspend is broken too. And I don't know if this has
any to do with the reported issues.

On 29-03-2014 12:15:35, Matthias Beyer wrote:
> Hi,
>=20
> I got this error with 3.13.7, which I just installed:
>=20
> ---
>=20
> M=E4r 29 11:53:05 fu kernel: BUG: unable to handle kernel NULL pointer de=
reference at           (null)
> M=E4r 29 11:53:05 fu kernel: IP: [<ffffffffa01f8317>] mousedev_open_devic=
e+0x77/0x100 [mousedev]
> M=E4r 29 11:53:05 fu kernel: PGD 400853067 PUD 400852067 PMD 0=20
> M=E4r 29 11:53:05 fu kernel: Oops: 0000 [#1] PREEMPT SMP=20
> M=E4r 29 11:53:05 fu kernel: Modules linked in: mousedev(+) btusb bluetoo=
th intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm =
btrfs iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi snd_hda_codec_conexan=
t raid6_pq libcrc32c xor nls_cp437 vfat fat arc4 iwldvm mac80211 microcode =
evdev pcspkr psmouse se
> M=E4r 29 11:53:05 fu kernel:  crc32c_intel ghash_clmulni_intel aesni_inte=
l aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ehci_pci sdhci_pci=
 ehci_hcd sdhci scsi_mod mmc_core usbcore usb_common i8042 serio
> M=E4r 29 11:53:05 fu kernel: CPU: 2 PID: 764 Comm: acpid Tainted: G      =
     O 3.13.7-1-ARCH #1
> M=E4r 29 11:53:05 fu kernel: Hardware name: LENOVO 4290A11/4290A11, BIOS =
8DET66WW (1.36 ) 10/22/2012
> M=E4r 29 11:53:05 fu kernel: task: ffff8804068c2400 ti: ffff88007fc62000 =
task.ti: ffff88007fc62000
> M=E4r 29 11:53:05 fu kernel: RIP: 0010:[<ffffffffa01f8317>]  [<ffffffffa0=
1f8317>] mousedev_open_device+0x77/0x100 [mousedev]
> M=E4r 29 11:53:05 fu kernel: RSP: 0018:ffff88007fc63c10  EFLAGS: 00010202
> M=E4r 29 11:53:05 fu kernel: RAX: 0000000000000000 RBX: ffff880406ded000 =
RCX: ffff880406ded068
> M=E4r 29 11:53:05 fu kernel: RDX: 0000000000000000 RSI: 0000000000000000 =
RDI: 0000000000000246
> M=E4r 29 11:53:05 fu kernel: RBP: ffff88007fc63c28 R08: 0000000000000000 =
R09: ffff88040d803600
> M=E4r 29 11:53:05 fu kernel: R10: 0000000000000000 R11: 0000000000000004 =
R12: 0000000000000000
> M=E4r 29 11:53:05 fu kernel: R13: ffff880406ded080 R14: ffff880400607238 =
R15: ffff880405e16f00
> M=E4r 29 11:53:05 fu kernel: FS:  00007f0469f18700(0000) GS:ffff88041e280=
000(0000) knlGS:0000000000000000
> M=E4r 29 11:53:05 fu kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
50033
> M=E4r 29 11:53:05 fu kernel: CR2: 0000000000000000 CR3: 00000000d9926000 =
CR4: 00000000000407e0
> M=E4r 29 11:53:05 fu kernel: Stack:
> M=E4r 29 11:53:05 fu kernel:  ffff880405c7fa00 ffff880406ded000 ffff88040=
6ded078 ffff88007fc63c60
> M=E4r 29 11:53:05 fu kernel:  ffffffffa01f90cc ffff880406ded348 ffff88040=
0607238 ffff880405e16f00
> M=E4r 29 11:53:05 fu kernel:  ffffffffa01f9e80 ffff880405e16f10 ffff88007=
fc63c98 ffffffff811a843f
> M=E4r 29 11:53:05 fu kernel: Call Trace:
> M=E4r 29 11:53:05 fu kernel:  [<ffffffffa01f90cc>] mousedev_open+0xcc/0x1=
50 [mousedev]
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a843f>] chrdev_open+0x9f/0x1d0
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a1ad7>] do_dentry_open+0x1b7/0=
x2c0
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811aeeb1>] ? __inode_permission+0=
x41/0xb0
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a83a0>] ? cdev_put+0x30/0x30
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a1ef1>] finish_open+0x31/0x40
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811b1ce2>] do_last+0x572/0xe90
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811af1a6>] ? link_path_walk+0x236=
/0x8d0
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff81135cf3>] ? unlock_page+0x23/0x30
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811b26bb>] path_openat+0xbb/0x6b0
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff81161084>] ? handle_mm_fault+0x26=
4/0xed0
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811b3dca>] do_filp_open+0x3a/0x90
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811c0677>] ? __alloc_fd+0xa7/0x130
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a30c4>] do_sys_open+0x124/0x220
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a31de>] SyS_open+0x1e/0x20
> M=E4r 29 11:53:05 fu kernel:  [<ffffffff81521b6d>] system_call_fastpath+0=
x1a/0x1f
> M=E4r 29 11:53:05 fu kernel: Code: e0 05 32 e1 5b 44 89 e0 41 5c 41 5d 5d=
 c3 66 0f 1f 44 00 00 4c 89 ef 41 bc ed ff ff ff e8 c2 05 32 e1 eb e0 48 8b=
 15 c9 21 00 00 <8b> 02 8d 48 01 85 c0 89 0a 75 c6 48 8b 05 37 1f 00 00 48 =
3d 60=20
> M=E4r 29 11:53:05 fu kernel: RIP  [<ffffffffa01f8317>] mousedev_open_devi=
ce+0x77/0x100 [mousedev]
> M=E4r 29 11:53:05 fu kernel:  RSP <ffff88007fc63c10>
> M=E4r 29 11:53:05 fu kernel: CR2: 0000000000000000
> M=E4r 29 11:53:05 fu kernel: ---[ end trace cea09d6c5d332dfc ]---
>=20
> ---
>=20
> I am on Archlinux, on a Thinkpad x220, if that matters. I will also
> write a message to the bugtracker as soon as my email addr gets
> verified.
>=20
> Regards!
>=20


--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTNxmKAAoJEJi+S08gyg+UOH8P/Rg7+Py88kDWWWIyfZWns2fO
blQdnok1nG0KugAEHIueZKfFdq1XwksS00dl05zhPM6GpUWWxKv2pv72HeyNxgr6
dY2WZMhx60nCauw+Xy71bAjzmMBRctLifqAuMM0vz22Fac5cHedLtlNbuQy4ag3k
GKmR4ieRBOjhCSs9P2M6eRrWMB8t3IexIzPKIW1oF5bL1eGF+qRCmRahLop2xF36
E7g0NDQciIc8IW3wZ4jD4/kPBKjji+yUUHNiAjMM6+LccwanrtTymjzEkOWPqdYM
IDlzwY0dMQrXioJrxPdfR5Zw795HzfO09WnnNyE7x57jUi3c4/QR8FEnsP8UQQ6A
WJFjN5YC62rS4yjbEqSuhbaSij6p4LUgpMx9C/XfzbtKWkdZXOXpR4x+hbimR4ej
pC0NiWdbUtEJKXuUM+LW2IiynZt/oxFNlDMHqRY7+AEyZw2VX7cueYWKxtLoFnDF
l7V7z1V+4Pnh7A8ErFZdHlnku3acN4DTxFRGM0D/bZF7srAvFDZMsg/28WFKd1V0
Jdgv3VcmryjCVk9zcf/ztlvBCAZHX3D57qaa4yQkxa9UnRqJudsNPxwUkBxAUeER
ObsMM0iSe0A8z10GmbggYFZVzq56bz9ldE1Lcf3b47IQmDwvB0budnzqN3TcrKll
F8Lkqfy/bjy3gDwWQK9v
=o0tX
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
