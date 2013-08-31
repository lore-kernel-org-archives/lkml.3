Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3HaQtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 12:49:43 -0400
Received: from plane.gmane.org ([80.91.229.3]:51633 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab3HaQtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 12:49:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: ael <law_ence.dev@ntlworld.com>
Subject: Re: Crashes on 3.0.11-rc7: nouveau?
Date: Sat, 31 Aug 2013 17:49:30 +0100
Message-ID: <kvt6qi$f7l$1@ger.gmane.org>
References: <kvsve9$5ou$1@ger.gmane.org> <CAKb7UvgnSjLpowUV3=0rozDQ6HENnY_cfrjQTCf2UMBH0uPvsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc2-oxfd23-2-0-cust674.4-3.cable.virginmedia.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
In-Reply-To: <CAKb7UvgnSjLpowUV3=0rozDQ6HENnY_cfrjQTCf2UMBH0uPvsQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/13 16:54, Ilia Mirkin wrote:
> On Sat, Aug 31, 2013 at 10:43 AM, ael<law_ence.dev@ntlworld.com>  wrote:

>
> This is not a crash, but a warning. Also one that should have been
> taken care of in 3.11-rc7 -- are you absolutely sure you're running
> that kernel and not some 3.11-rc6+ one? This is the commit that should
> have fixed it (and worked great for me):
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=78ae0ad403daf11cf63da86923d2b5dbeda3af8f
>
> Based on what you pasted, you were actually running "3.11.0-rc4_c2+"
> which probably didn't contain the above commit.

My apologies. I realized after posting that I had two extracts, the 
first on 3.11.0-rc4, as you noticed.

The second, below (original quote) was really from 3.0.11-rc7, but not 
obviously connected with nouveau. But perhaps from skge?

>> =============================================================================
>>
>>
>> Aug 31 12:54:56 conquest2 kernel: general protection fault: 0000 [#1]
>> Aug 31 12:54:56 conquest2 kernel: Modules linked in: rpcsec_gss_krb5 nfsv4
>> snd_hrtimer cpufreq_userspace cpufreq_stats cpufreq_powersave lp hwmon_vid
>> nfsd auth_
>> rpcgss oid_registry exportfs nfs_acl nfs lockd sunrpc ipv6 analog joydev
>> dm_crypt dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
>> snd_mixer_oss snd_pcm
>> nouveau video backlight fbcon snd_page_alloc mxm_wmi snd_seq_dummy
>> snd_mpu401 snd_mpu401_uart bitblit psmouse snd_seq_oss softcursor wmi
>> snd_seq_midi ttm font s
>> nd_rawmidi drm_kms_helper snd_seq_midi_event sg snd_seq drm i2c_algo_bit
>> sr_mod k8temp cdrom hwmon forcedeth serio_raw ohci_pci snd_seq_device pcspkr
>> evdev ohci
>> _hcd snd_timer snd ns558 gameport ehci_pci ehci_hcd i2c_nforce2 i2c_core
>> parport_pc parport floppy soundcore thermal processor button unix
>> Aug 31 12:54:56 conquest2 kernel: CPU: 0 PID: 5555 Comm: ifconfig Not
>> tainted 3.11.0-rc7_c2+ #100
>> Aug 31 12:54:56 conquest2 kernel: Hardware name: System manufacturer System
>> name/A8N-SLI DELUXE, BIOS ASUS A8N-SLI DELUXE ACPI BIOS Revision 1805
>> 09/29/2006
>> Aug 31 12:54:56 conquest2 kernel: task: ffff88007d3f4150 ti:
>> ffff88000156e000 task.ti: ffff88000156e000
>> Aug 31 12:54:56 conquest2 kernel: RIP: 0010:[<ffffffff813846b3>]
>> [<ffffffff813846b3>] cache_flusharray+0x15/0x77
>> Aug 31 12:54:56 conquest2 kernel: RSP: 0018:ffff88000156fc10  EFLAGS:
>> 00010046
>> Aug 31 12:54:56 conquest2 kernel: RAX: 400000000000082c RBX:
>> 0000000001228d30 RCX: 4000000000000064
>> Aug 31 12:54:56 conquest2 kernel: RDX: ffffea000089db98 RSI:
>> 0000000001228d30 RDI: ffff8800500aa950
>> Aug 31 12:54:56 conquest2 kernel: RBP: ffff88000156fc20 R08:
>> 0000000000000001 R09: 0000000000000000
>> Aug 31 12:54:56 conquest2 kernel: R10: ffffc90000018434 R11:
>> ffffc90000018000 R12: 0000000000000000
>> Aug 31 12:54:56 conquest2 kernel: R13: ffff880027635800 R14:
>> 0000000000000000 R15: ffff88007c85c000
>> Aug 31 12:54:56 conquest2 kernel: FS:  00007f6d57661700(0000)
>> GS:ffffffff814df000(0000) knlGS:0000000000000000
>> Aug 31 12:54:56 conquest2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> 000000008005003b
>> Aug 31 12:54:56 conquest2 kernel: CR2: 0000000001228d34 CR3:
>> 0000000005621000 CR4: 00000000000007f0
>> Aug 31 12:54:56 conquest2 kernel: Stack:
>> Aug 31 12:54:56 conquest2 kernel: 0000000001228d30 0000000000000286
>> ffff88000156fc48 ffffffff810e09de
>> Aug 31 12:54:56 conquest2 kernel: ffff8800276358c0 ffff88007c85c660
>> ffff880036632080 ffff88000156fc58
>> Aug 31 12:54:56 conquest2 kernel: ffffffff81300a7c ffff88000156fc80
>> ffffffff81302b22 ffff880036632080
>> Aug 31 12:54:56 conquest2 kernel: Call Trace:
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff810e09de>] kfree+0xbe/0xd0
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81300a7c>]
>> skb_free_head+0x6c/0x80
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81302b22>]
>> skb_release_data+0xe2/0xf0
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81302b4f>]
>> skb_release_all+0x1f/0x30
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81302b6d>] __kfree_skb+0xd/0x90
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81302c08>] consume_skb+0x18/0x40
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff812b4dab>]
>> skge_rx_clean+0x4b/0xa0
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff812b8a45>] skge_down+0x3f5/0x520
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8130a955>]
>> __dev_close_many+0x75/0xc0
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8130a9c8>] __dev_close+0x28/0x40
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8130e6cc>]
>> __dev_change_flags+0x9c/0x180
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8130e863>]
>> dev_change_flags+0x23/0x70
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8135e0fb>]
>> devinet_ioctl+0x5ab/0x660
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8135eeb4>] inet_ioctl+0x74/0x90
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff812f8b4c>]
>> sock_do_ioctl.constprop.46+0x1c/0x50
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff812f8df8>] sock_ioctl+0x58/0x2b0
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff810f973c>]
>> do_vfs_ioctl+0x7c/0x4e0
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff810f39fd>] ?
>> final_putname+0x1d/0x40
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff810f9c31>] SyS_ioctl+0x91/0xb0
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81053339>] ?
>> do_page_fault+0x9/0x10
>> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81388bd0>]
>> system_call_fastpath+0x16/0x1b
>> Aug 31 12:54:56 conquest2 kernel: Code: 8b 52 30 48 8b 0a 48 89 c2 48 83 ca
>> 01 5d 80 e1 40 48 0f 45 c2 c3 55 48 89 e5 41 54 53 48 8b 47 78 48 89 f3 44
>> 8b 66 08 48 8b 00<48>  8b 40 40 48 85 c0 74 2a 8b 10 8b 48 04 29 d1 74 21 41
>> 39 cc
>> Aug 31 12:54:56 conquest2 kernel: RSP<ffff88000156fc10>
>> Aug 31 12:54:56 conquest2 kernel: ---[ end trace 41fcd322c82e6632 ]---
>>
>> =======================================================================

ael



