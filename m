Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab3CSAvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:51:40 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:33356 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3CSAvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
Date: Mon, 18 Mar 2013 18:51:37 -0600
Message-ID: <CAKocOOMj7HMi-v1_KiYh=L_rKb1K6Mcu-vC8momC1iUzJbZmaA@mail.gmail.com>
Subject: Re: [ 00/75] 3.8.4-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 3:06 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.8.4 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar 20 21:04:55 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.4-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Here is the warn from 3.8.4-rc1
[  700.009112] Component: resume devices, time: 10004
[  700.009204] Modules linked in: ip6table_filter ip6_tables
ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc bnep rfcomm bluetooth
arc4 iwldvm snd_hda_codec_analog radeon snd_hda_intel mac80211
coretemp snd_hda_codec kvm_intel kvm snd_hwdep binfmt_misc snd_pcm
snd_seq_midi iwlwifi snd_rawmidi ttm snd_seq_midi_event cfg80211
drm_kms_helper pata_pcmcia snd_seq tpm_infineon drm psmouse snd_timer
joydev pcmcia snd_seq_device snd yenta_socket tpm_tis microcode
pcmcia_rsrc pcmcia_core ppdev dm_multipath i2c_algo_bit video hp_wmi
mac_hid sparse_keymap serio_raw soundcore snd_page_alloc lpc_ich wmi
hp_accel lis3lv02d input_polldev parport_pc lp parport firewire_ohci
sdhci_pci sdhci firewire_core crc_itu_t e1000e
[  700.009212] Pid: 2637, comm: bash Not tainted 3.8.4-rc1+ #8
[  700.009213] Call Trace:
[  700.009225]  [<ffffffff8105821f>] warn_slowpath_common+0x7f/0xc0
[  700.009231]  [<ffffffff81058316>] warn_slowpath_fmt+0x46/0x50
[  700.009237]  [<ffffffff810a3196>] suspend_test_finish+0x86/0x90
[  700.009243]  [<ffffffff810a2d3e>] suspend_devices_and_enter+0x16e/0x330
[  700.009248]  [<ffffffff810a308f>] pm_suspend+0x18f/0x1f0
[  700.009254]  [<ffffffff810a208e>] state_store+0x8e/0xf0
[  700.009261]  [<ffffffff8133218f>] kobj_attr_store+0xf/0x30
[  700.009268]  [<ffffffff811fae0f>] sysfs_write_file+0xef/0x170
[  700.009274]  [<ffffffff811879e3>] vfs_write+0xb3/0x180
[  700.009278]  [<ffffffff81187d22>] sys_write+0x52/0xa0
[  700.009284]  [<ffffffff811a4810>] ? __close_fd+0x90/0xc0
[  700.009291]  [<ffffffff816b4bd9>] system_call_fastpath+0x16/0x1b
[  700.009294] ---[ end trace f7ca5ea4ac88428b ]---
[  700.009728] PM: Finishing wakeup.
[  700.009731] Restarting tasks ... done.

-- Shuah
