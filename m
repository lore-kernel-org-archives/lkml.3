Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaC2LYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 07:24:11 -0400
Received: from libra.uberspace.de ([95.143.172.171]:41745 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751375AbaC2LYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 07:24:08 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Mar 2014 07:24:08 EDT
Date: Sat, 29 Mar 2014 12:15:35 +0100
From: Matthias Beyer <mail@beyermatthias.de>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 3.14-rc6 at mousedev_open_device+0x77/0x100
Message-ID: <20140329111535.GA4275@fu.192.168.200.1>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1513450.PT1cqDJBLI@grover>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <1513450.PT1cqDJBLI@grover>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I got this error with 3.13.7, which I just installed:

---

M=E4r 29 11:53:05 fu kernel: BUG: unable to handle kernel NULL pointer dere=
ference at           (null)
M=E4r 29 11:53:05 fu kernel: IP: [<ffffffffa01f8317>] mousedev_open_device+=
0x77/0x100 [mousedev]
M=E4r 29 11:53:05 fu kernel: PGD 400853067 PUD 400852067 PMD 0=20
M=E4r 29 11:53:05 fu kernel: Oops: 0000 [#1] PREEMPT SMP=20
M=E4r 29 11:53:05 fu kernel: Modules linked in: mousedev(+) btusb bluetooth=
 intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm bt=
rfs iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi snd_hda_codec_conexant =
raid6_pq libcrc32c xor nls_cp437 vfat fat arc4 iwldvm mac80211 microcode ev=
dev pcspkr psmouse se
M=E4r 29 11:53:05 fu kernel:  crc32c_intel ghash_clmulni_intel aesni_intel =
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ehci_pci sdhci_pci e=
hci_hcd sdhci scsi_mod mmc_core usbcore usb_common i8042 serio
M=E4r 29 11:53:05 fu kernel: CPU: 2 PID: 764 Comm: acpid Tainted: G        =
   O 3.13.7-1-ARCH #1
M=E4r 29 11:53:05 fu kernel: Hardware name: LENOVO 4290A11/4290A11, BIOS 8D=
ET66WW (1.36 ) 10/22/2012
M=E4r 29 11:53:05 fu kernel: task: ffff8804068c2400 ti: ffff88007fc62000 ta=
sk.ti: ffff88007fc62000
M=E4r 29 11:53:05 fu kernel: RIP: 0010:[<ffffffffa01f8317>]  [<ffffffffa01f=
8317>] mousedev_open_device+0x77/0x100 [mousedev]
M=E4r 29 11:53:05 fu kernel: RSP: 0018:ffff88007fc63c10  EFLAGS: 00010202
M=E4r 29 11:53:05 fu kernel: RAX: 0000000000000000 RBX: ffff880406ded000 RC=
X: ffff880406ded068
M=E4r 29 11:53:05 fu kernel: RDX: 0000000000000000 RSI: 0000000000000000 RD=
I: 0000000000000246
M=E4r 29 11:53:05 fu kernel: RBP: ffff88007fc63c28 R08: 0000000000000000 R0=
9: ffff88040d803600
M=E4r 29 11:53:05 fu kernel: R10: 0000000000000000 R11: 0000000000000004 R1=
2: 0000000000000000
M=E4r 29 11:53:05 fu kernel: R13: ffff880406ded080 R14: ffff880400607238 R1=
5: ffff880405e16f00
M=E4r 29 11:53:05 fu kernel: FS:  00007f0469f18700(0000) GS:ffff88041e28000=
0(0000) knlGS:0000000000000000
M=E4r 29 11:53:05 fu kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
M=E4r 29 11:53:05 fu kernel: CR2: 0000000000000000 CR3: 00000000d9926000 CR=
4: 00000000000407e0
M=E4r 29 11:53:05 fu kernel: Stack:
M=E4r 29 11:53:05 fu kernel:  ffff880405c7fa00 ffff880406ded000 ffff880406d=
ed078 ffff88007fc63c60
M=E4r 29 11:53:05 fu kernel:  ffffffffa01f90cc ffff880406ded348 ffff8804006=
07238 ffff880405e16f00
M=E4r 29 11:53:05 fu kernel:  ffffffffa01f9e80 ffff880405e16f10 ffff88007fc=
63c98 ffffffff811a843f
M=E4r 29 11:53:05 fu kernel: Call Trace:
M=E4r 29 11:53:05 fu kernel:  [<ffffffffa01f90cc>] mousedev_open+0xcc/0x150=
 [mousedev]
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a843f>] chrdev_open+0x9f/0x1d0
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a1ad7>] do_dentry_open+0x1b7/0x2=
c0
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811aeeb1>] ? __inode_permission+0x4=
1/0xb0
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a83a0>] ? cdev_put+0x30/0x30
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a1ef1>] finish_open+0x31/0x40
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811b1ce2>] do_last+0x572/0xe90
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811af1a6>] ? link_path_walk+0x236/0=
x8d0
M=E4r 29 11:53:05 fu kernel:  [<ffffffff81135cf3>] ? unlock_page+0x23/0x30
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811b26bb>] path_openat+0xbb/0x6b0
M=E4r 29 11:53:05 fu kernel:  [<ffffffff81161084>] ? handle_mm_fault+0x264/=
0xed0
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811b3dca>] do_filp_open+0x3a/0x90
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811c0677>] ? __alloc_fd+0xa7/0x130
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a30c4>] do_sys_open+0x124/0x220
M=E4r 29 11:53:05 fu kernel:  [<ffffffff811a31de>] SyS_open+0x1e/0x20
M=E4r 29 11:53:05 fu kernel:  [<ffffffff81521b6d>] system_call_fastpath+0x1=
a/0x1f
M=E4r 29 11:53:05 fu kernel: Code: e0 05 32 e1 5b 44 89 e0 41 5c 41 5d 5d c=
3 66 0f 1f 44 00 00 4c 89 ef 41 bc ed ff ff ff e8 c2 05 32 e1 eb e0 48 8b 1=
5 c9 21 00 00 <8b> 02 8d 48 01 85 c0 89 0a 75 c6 48 8b 05 37 1f 00 00 48 3d=
 60=20
M=E4r 29 11:53:05 fu kernel: RIP  [<ffffffffa01f8317>] mousedev_open_device=
+0x77/0x100 [mousedev]
M=E4r 29 11:53:05 fu kernel:  RSP <ffff88007fc63c10>
M=E4r 29 11:53:05 fu kernel: CR2: 0000000000000000
M=E4r 29 11:53:05 fu kernel: ---[ end trace cea09d6c5d332dfc ]---

---

I am on Archlinux, on a Thinkpad x220, if that matters. I will also
write a message to the bugtracker as soon as my email addr gets
verified.

Regards!

On 10-03-2014 12:07:56, Ed Tomlinson wrote:
> Hi
>=20
> This happens every couple of boots with 3.14-rc kernels have not noticed =
it with 3.13.  Not really sure where else this should be sent...
>=20
> Mar 10 10:45:05 localhost kernel: [    4.740750] BUG: unable to handle ke=
rnel NULL pointer dereference at           (null)
> Mar 10 10:45:05 localhost kernel: [    4.740845] IP: [<ffffffffa02ee317>]=
 mousedev_open_device+0x77/0x100 [mousedev]
> Mar 10 10:45:05 localhost kernel: [    4.740930] PGD 412cfa067 PUD 41881e=
067 PMD 0=20
> Mar 10 10:45:05 localhost kernel: [    4.740989] Oops: 0000 [#1] PREEMPT =
SMP=20
> Mar 10 10:45:05 localhost kernel: [    4.741043] Modules linked in: mouse=
dev(+) pl2303 usbserial btusb joydev hid_generic snd_usb_audio usbhid snd_u=
sbmidi_lib snd_
> rawmidi hid snd_seq_device zram nct6775 hwmon_vid radeon ttm btrfs snd_hd=
a_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi raid6_pq xor iTCO_=
wdt iTCO_vendor
> _support x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crc=
t10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes=
_x86_64 lrw gf1
> 28mul glue_helper ablk_helper cryptd psmouse pcspkr i2c_i801 serio_raw tp=
m_tis tpm i915 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm drm_kms_helper=
 mei_me snd_tim
> er e1000e drm nuvoton_cir mei snd rc_core shpchp intel_gtt ptp i2c_algo_b=
it pps_core soundcore lpc_ich evdev microcode ath3k bluetooth 6lowpan_iphc =
rfkill gspca_pa
> c7311 gspca_ov519 gspca_main videodev media i2c_core video acpi_power_met=
er thermal processor pci chipreg mtd fan button battery acpi_pad acpi_ipmi =
ipmi_msghandler
>  ext4 crc16 mbcache jbd2 usb_storage sd_mod crc_t10dif crct10dif_common a=
tkbd libps2 ahci libahci libata ehci_pci xhci_hcd ehci_hcd scsi_mod usbcore=
 usb_common i80
> 42 serio
> Mar 10 10:45:05 localhost kernel: [    4.742722] CPU: 4 PID: 338 Comm: ac=
pid Not tainted 3.14.0-1-mainline #1
> Mar 10 10:45:05 localhost kernel: [    4.742822] Hardware name: To Be Fil=
led By O.E.M. To Be Filled By O.E.M./Z87E-ITX, BIOS P2.30 12/06/2013
> Mar 10 10:45:05 localhost kernel: [    4.742916] task: ffff8804170889e0 t=
i: ffff8800c2800000 task.ti: ffff8800c2800000
> Mar 10 10:45:05 localhost kernel: [    4.743013] RIP: 0010:[<ffffffffa02e=
e317>]  [<ffffffffa02ee317>] mousedev_open_device+0x77/0x100 [mousedev]
> Mar 10 10:45:05 localhost kernel: [    4.743015] RSP: 0018:ffff8800c2801c=
10  EFLAGS: 00010202
> Mar 10 10:45:05 localhost kernel: [    4.743021] RAX: 0000000000000000 RB=
X: ffff880404650800 RCX: ffff880404650868
> Mar 10 10:45:05 localhost kernel: [    4.743023] RDX: 0000000000000000 RS=
I: 0000000000000000 RDI: 0000000000000246
> Mar 10 10:45:05 localhost kernel: [    4.743024] RBP: ffff8800c2801c28 R0=
8: 0000000000000000 R09: ffff88041e803600
> Mar 10 10:45:05 localhost kernel: [    4.743025] R10: 0000000000000000 R1=
1: 0000000000000004 R12: 0000000000000000
> Mar 10 10:45:05 localhost kernel: [    4.743027] R13: ffff880404650880 R1=
4: ffff88040a78f778 R15: ffff880417744c00
> Mar 10 10:45:05 localhost kernel: [    4.743029] FS:  00007f93d2f6c700(00=
00) GS:ffff88042f300000(0000) knlGS:0000000000000000
> Mar 10 10:45:05 localhost kernel: [    4.743031] CS:  0010 DS: 0000 ES: 0=
000 CR0: 0000000080050033
> Mar 10 10:45:05 localhost kernel: [    4.743032] CR2: 0000000000000000 CR=
3: 0000000417542000 CR4: 00000000001407e0
> Mar 10 10:45:05 localhost kernel: [    4.743033] Stack:
> Mar 10 10:45:05 localhost kernel: [    4.743038]  ffff880412de1c00 ffff88=
0404650800 ffff880404650878 ffff8800c2801c60
> Mar 10 10:45:05 localhost kernel: [    4.743041]  ffffffffa02ef0cc ffff88=
0404650b48 ffff88040a78f778 ffff880417744c00
> Mar 10 10:45:05 localhost kernel: [    4.743045]  ffffffffa02efe80 ffff88=
0417744c10 ffff8800c2801c98 ffffffff811b5e2f
> Mar 10 10:45:05 localhost kernel: [    4.743046] Call Trace:
> Mar 10 10:45:05 localhost kernel: [    4.743054]  [<ffffffffa02ef0cc>] mo=
usedev_open+0xcc/0x150 [mousedev]
> Mar 10 10:45:05 localhost kernel: [    4.743061]  [<ffffffff811b5e2f>] ch=
rdev_open+0x9f/0x1d0
> Mar 10 10:45:05 localhost kernel: [    4.743068]  [<ffffffff811af527>] do=
_dentry_open+0x1b7/0x2c0
> Mar 10 10:45:05 localhost kernel: [    4.743073]  [<ffffffff811bc7e1>] ? =
__inode_permission+0x41/0xb0
> Mar 10 10:45:05 localhost kernel: [    4.743077]  [<ffffffff811b5d90>] ? =
cdev_put+0x30/0x30
> Mar 10 10:45:05 localhost kernel: [    4.743081]  [<ffffffff811af941>] fi=
nish_open+0x31/0x40
> Mar 10 10:45:05 localhost kernel: [    4.743086]  [<ffffffff811bf612>] do=
_last+0x572/0xe90
> Mar 10 10:45:05 localhost kernel: [    4.743091]  [<ffffffff811bcad6>] ? =
link_path_walk+0x236/0x8d0
> Mar 10 10:45:05 localhost kernel: [    4.743097]  [<ffffffff811bffeb>] pa=
th_openat+0xbb/0x6b0
> Mar 10 10:45:05 localhost kernel: [    4.743102]  [<ffffffff811c16fa>] do=
_filp_open+0x3a/0x90
> Mar 10 10:45:05 localhost kernel: [    4.743106]  [<ffffffff811cddf7>] ? =
__alloc_fd+0xa7/0x130
> Mar 10 10:45:05 localhost kernel: [    4.743111]  [<ffffffff811b0b14>] do=
_sys_open+0x124/0x220
> Mar 10 10:45:05 localhost kernel: [    4.743116]  [<ffffffff811b0c2e>] Sy=
S_open+0x1e/0x20
> Mar 10 10:45:05 localhost kernel: [    4.743120]  [<ffffffff8153702d>] sy=
stem_call_fastpath+0x1a/0x1f
> Mar 10 10:45:05 localhost kernel: [    4.743151] Code: c0 f2 23 e1 5b 44 =
89 e0 41 5c 41 5d 5d c3 66 0f 1f 44 00 00 4c 89 ef 41 bc ed ff ff ff e8 a2 =
f2 23 e1 eb e0=20
> 48 8b 15 c9 21 00 00 <8b> 02 8d 48 01 85 c0 89 0a 75 c6 48 8b 05 37 1f 00=
 00 48 3d 60=20
> Mar 10 10:45:05 localhost kernel: [    4.743156] RIP  [<ffffffffa02ee317>=
] mousedev_open_device+0x77/0x100 [mousedev]
> Mar 10 10:45:05 localhost kernel: [    4.743157]  RSP <ffff8800c2801c10>
> Mar 10 10:45:05 localhost kernel: [    4.743158] CR2: 0000000000000000
> Mar 10 10:45:05 localhost kernel: [    4.743200] ---[ end trace 9ee5bcb02=
f264a08 ]---
>=20
> The bug does not seem to hurt things much but...
>=20
> TIA
> Ed Tomlinson
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTNqtXAAoJEJi+S08gyg+UhggQAIjKJPJmFpUn/DIK45gsJHA5
1P1GEDcO/EOCNMRQsli8fge2D5WEu0A1zOmWb98ikhMFETiCjgVy5cEVyEK577u5
k9nGTzFSsXh7q1lN5k9Hq8pjcTID5ZjXF+fTBt+Z7LDSy4jLP3LXV55Tj/0aBd3P
+Nlf7cahlEuf/lQWuaj5VxEsSxO0fRS+GzKiFDbH82iuB5sAv7fsB/V+cUfZtbu5
GhHnyoVtiA+MSotD00Y1TY2L6/+dyvU/LstRapjXuKMjjUTgIPNFarc/BsmBBQtR
WfbKpDAhnjlQw3TwCU7f2kc2htp2tKIJ67TtgQtOeL7zKOknSzzIRYPW1SKqxEFP
Y8iI/lNbGUyN+oCM7UYY6ywjT8ZtUfWbCuHiv/gPvp1XGcSgKh6kbtwU5pDjPTLW
9MbCQsxP6SHojMD47FlvTf57AbqhJX/ZdCYW64sOk1UhDMSatww6EJThCa89qXPi
jkrpNn3gdBGS/mVY0cAUV9GrDAgHmbYX0n5+dFYH4Tu0X3lRh9aSVGiRaco0gZtX
d6ZHZkyhpAGM7L/W0OAbD395Z3BV7GTFZ1ngUWwTBeXvh2P4UWgAzNsLQFJxDpI+
bpwI8F5NW0I00ShSgcaNTIcVUoatuD8vv+rUtiWJTedyTVXHWGMHgSCONZsOu6jJ
GRm6WPT9r1Nsz3qRj/DV
=bV1X
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
