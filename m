Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaGYXV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:21:27 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:55103 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaGYXV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:21:26 -0400
MIME-Version: 1.0
In-Reply-To: <27687.1406330345@turing-police.cc.vt.edu>
References: <CAPDOMVhgNzCMAr_XxVPec=p_hBP4piKLVzw_1O+tUFOxNzzQ0g@mail.gmail.com>
	<27687.1406330345@turing-police.cc.vt.edu>
Date: Fri, 25 Jul 2014 19:21:24 -0400
Message-ID: <CAPDOMVi1pRCWHuxtgNq7wQ20O_3B6cgyL_bvthrvcXZiFGikMw@mail.gmail.com>
Subject: Re: Kernel 3.16-rc6 Bug with Sound?
From: Nick Krause <xerofoify@gmail.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 7:19 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 25 Jul 2014 18:57:33 -0400, Nick Krause said:
>
>> Hey guys after compiling and running the kernel in the subject line I
>> get no sound
>> and a message of no sound codec could be found. I am new so this may be
>> a  missed needed config for sound or it's a bug. I am attaching my config
>> to help you guys out :).
>
> You want to *really* be helpful, you could tell us what lspci/lsusb/etc
> say your sound card is, so we can tell you which driver you forgot to
> include in your kernel config. :)
>
>
Sorry again , I need to get used to not holding my hand :).
Sure I will paste below the lsmod output I get on a Ubuntu
distro kernel that works.
eeepc_wmi              13151  0
asus_wmi               24191  1 eeepc_wmi
sparse_keymap          13948  1 asus_wmi
snd_hda_codec_hdmi     46254  1
dm_multipath           22873  0
scsi_dh                14882  1 dm_multipath
intel_rapl             18773  0
x86_pkg_temp_thermal    14205  0
intel_powerclamp       14705  0
kvm_intel             143060  0
kvm                   451511  1 kvm_intel
crct10dif_pclmul       14289  0
crc32_pclmul           13113  0
ghash_clmulni_intel    13216  0
aesni_intel            55624  0
snd_hda_codec_realtek    61438  1
aes_x86_64             17131  1 aesni_intel
lrw                    13286  1 aesni_intel
gf128mul               14951  1 lrw
glue_helper            13990  1 aesni_intel
ablk_helper            13597  1 aesni_intel
cryptd                 20359  3 ghash_clmulni_intel,aesni_intel,ablk_helper
rfcomm                 69160  4
bnep                   19624  2
snd_hda_intel          52355  5
snd_hda_codec         192906  3
snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_intel
serio_raw              13462  0
snd_hwdep              13602  1 snd_hda_codec
bluetooth             391196  10 bnep,rfcomm
snd_pcm               102099  3 snd_hda_codec_hdmi,snd_hda_codec,snd_hda_intel
snd_page_alloc         18710  2 snd_pcm,snd_hda_intel
snd_seq_midi           13324  0
snd_seq_midi_event     14899  1 snd_seq_midi
snd_rawmidi            30144  1 snd_seq_midi
lpc_ich                21080  0
snd_seq                61560  2 snd_seq_midi_event,snd_seq_midi
snd_seq_device         14497  3 snd_seq,snd_rawmidi,snd_seq_midi
snd_timer              29482  2 snd_pcm,snd_seq
mac_hid                13205  0
parport_pc             32701  0
binfmt_misc            17468  1
ppdev                  17671  0
snd                    69238  21
snd_hda_codec_realtek,snd_hwdep,snd_timer,snd_hda_codec_hdmi,snd_pcm,snd_seq,snd_rawmidi,snd_hda_codec,snd_hda_intel,snd_seq_device,snd_seq_midi
nct6775                55222  0
hwmon_vid              12783  1 nct6775
fglrx                8815330  97
mei_me                 18627  0
coretemp               13435  0
lp                     17759  0
amd_iommu_v2           19054  1 fglrx
parport                42348  3 lp,ppdev,parport_pc
mei                    82276  1 mei_me
soundcore              12680  1 snd
nls_iso8859_1          12713  1
btrfs                 835954  0
ses                    17363  0
enclosure              15368  1 ses
xor                    21411  1 btrfs
raid6_pq               97812  1 btrfs
libcrc32c              12644  1 btrfs
dm_mirror              22135  0
dm_region_hash         20862  1 dm_mirror
dm_log                 18411  2 dm_region_hash,dm_mirror
hid_generic            12548  0
usbhid                 52570  0
hid                   106148  2 hid_generic,usbhid
usb_storage            62209  0
ahci                   25819  4
r8169                  67581  0
libahci                32560  1 ahci
mii                    13934  1 r8169
video                  19476  1 asus_wmi
wmi                    19177  1 asus_wmi
