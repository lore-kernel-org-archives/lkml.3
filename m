Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaLPA5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:57:09 -0500
Received: from nm23-vm8.access.bullet.mail.bf1.yahoo.com ([216.109.115.167]:47732
	"EHLO nm23-vm8.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbaLPA5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:57:07 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2014 19:57:07 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=rogers.com;
	b=SBJSkrRiXmSgZaX1aB+GeFdP8LDY3ExO3eg91gevEdYblYcmuRTe5J+9NEMFo2Wl5lBg7XsyN1pgGsZtdZN26W+sxcpNn6jEhRNCtp/4EE9HkhPvIaeJlaUsDxUwLNpIn8xidAbjMDK2SDHDxoFvKDSdMrOxkeq3VlYZ2HC5aV4DZwMd2ATkSeSod9pfReKyFLl3ijZbxmi/zzqhYUvlchdLKxPiMcb5+xOs4Is3k1OKuAsiJVg9Jrw0a6PjEPx9ritL3xu6eAc95HjTM3SIhr34m9tYQxksze1yZpv4ZKXznJ5dccKcmh9Y95/GzvtwgaNVYrcp/5YiBAyddYWBxg==;
X-Yahoo-Newman-Id: 512652.48933.bm@smtp116.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gh06XbcVM1ku7KbMbQwWps9_2jm3D7sWd_VyJwA6O4ayDC4
 vpEKjEsZImNes_oN0eR7e06So9aircQ3jY0cVLmTPFbISWpnOj26YcEdZOko
 XOM3eMCvNHGGR3qkYd.cmkdFFcWQdvU6el1xJNUK6eFrc4cp8USVpbG2EnVB
 HEsMW84Wd.fxLi0kamPRoUYbwCtefq9t.yAoeFZhyNU_61KSANpvxo6AKFN1
 PD_AFUzE4LO9jA2K081r3Y01rY17AvTVUhMNbuTuINY0P92MzVw9lZRO56m2
 A2lPfJl9zXj9zJK6gfg.QA0WdMJd0NPPTeCcoXwLzxHyg0SXEXtGUD69hu70
 zU6QOy15ew2RTGpF5zwNZL1u12gzgWqBWtOITX4QRLy0H16EOZhmXJh3a_JW
 nXjX2c62Bhldkm44kZdkadJvcwQoHI05EL_gNqcrkF1bLboQ7DnXfwWCiGFK
 1BZanm5pSWQx784k7CwKxzPFMdbU9kjgYHroNYrBoIDCn9oLSgmVcKW4ziyP
 RsFRdHfkQ4M1hZlvUlirQF.xR3f9VPxrHt5nz.5iC_w--
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: Kernel development list <linux-kernel@vger.kernel.org>,
        alsa-user@lists.sourceforge.net
Subject: [alsa][intel-hda] Dell M6800 - Realtek ALC3226 - Headphone Microphone not detected/working
Date: Mon, 15 Dec 2014 19:49:58 -0500
Message-ID: <4163174.cv3dxoLyRx@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.14.3 (Linux/3.18.0+; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ALSA/Kernel devs,

I have a Dell Precision M6800 with latest BIOS here is output from the HDA driver

[   20.783635] snd_hda_intel 0000:00:03.0: enabling device (0000 -> 0002)
[   20.783804] snd_hda_intel 0000:00:1b.0: irq 34 for MSI/MSI-X
[   20.783911] snd_hda_intel 0000:01:00.1: Handle VGA-switcheroo audio client
[   20.783914] snd_hda_intel 0000:01:00.1: VGA controller is disabled
[   20.783914] snd_hda_intel 0000:01:00.1: Delaying initialization
[   20.785722] snd_hda_intel 0000:00:03.0: irq 35 for MSI/MSI-X
[   20.798841] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card1/input16
[   20.798881] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card1/input17
[   20.798914] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card1/input18
[   20.800208] sound hdaudioC2D0: autoconfig: line_outs=1 (0x16/0x0/0x0/0x0/0x0) type:line
[   20.800209] sound hdaudioC2D0:    speaker_outs=1 (0x14/0x0/0x0/0x0/0x0)
[   20.800210] sound hdaudioC2D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[   20.800210] sound hdaudioC2D0:    mono: mono_out=0x0
[   20.800211] sound hdaudioC2D0:    inputs:
[   20.800212] sound hdaudioC2D0:      Front Mic=0x18
[   20.800212] sound hdaudioC2D0:      Dock Mic=0x19
[   20.800213] sound hdaudioC2D0:      Headset Mic=0x1a
[   20.800213] sound hdaudioC2D0:      Internal Mic=0x12
[   20.805683] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card2/input19
[   20.805724] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card2/input20
[   20.805756] input: HDA Intel PCH Dock Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card2/input21
[   20.805784] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card2/input22
[   78.191344] snd_hda_intel 0000:01:00.1: Start delayed initialization
[   78.195309] snd_hda_intel 0000:01:00.1: irq 36 for MSI/MSI-X
[   78.298530] snd_hda_intel 0000:01:00.1: CORB reset timeout#2, CORBRP = 65535
[   78.300524] snd_hda_intel 0000:01:00.1: no AFG or MFG node found
[   78.303813] snd_hda_intel 0000:01:00.1: no AFG or MFG node found
[   78.306054] snd_hda_intel 0000:01:00.1: no AFG or MFG node found
[   78.308797] snd_hda_intel 0000:01:00.1: no AFG or MFG node found
[   78.311717] snd_hda_intel 0000:01:00.1: no codecs initialized
[   78.314116] snd_hda_intel 0000:01:00.1: initialization error
[  264.477548] snd_hda_intel 0000:00:1b.0: Unstable LPIB (352800 >= 176400); disabling LPIB delay counting
[  381.091720] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[  381.095346] snd_hda_intel 0000:01:00.1: Handle VGA-switcheroo audio client
[  381.097754] snd_hda_intel 0000:01:00.1: VGA controller is disabled
[  381.100294] snd_hda_intel 0000:01:00.1: Delaying initialization

When I have the analog headphones plugged in the headphone speakers work but microphone does not, interestingly in another OS, it also didn't show it functioning.

If someone has had similar issues in Linux, let me know, I will also test patches.

Thanks,
Shawn



