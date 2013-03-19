Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab3CSA4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:56:09 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:38556 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab3CSA4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:56:06 -0400
Date: Mon, 18 Mar 2013 17:57:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/75] 3.8.4-stable review
Message-ID: <20130319005721.GA20560@kroah.com>
References: <20130318210510.203500214@linuxfoundation.org>
 <CAKocOOMj7HMi-v1_KiYh=L_rKb1K6Mcu-vC8momC1iUzJbZmaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOOMj7HMi-v1_KiYh=L_rKb1K6Mcu-vC8momC1iUzJbZmaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 06:51:37PM -0600, Shuah Khan wrote:
> On Mon, Mar 18, 2013 at 3:06 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 3.8.4 release.
> > There are 75 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed Mar 20 21:04:55 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.4-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Here is the warn from 3.8.4-rc1
> [  700.009112] Component: resume devices, time: 10004
> [  700.009204] Modules linked in: ip6table_filter ip6_tables
> ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
> nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
> iptable_filter ip_tables x_tables bridge stp llc bnep rfcomm bluetooth
> arc4 iwldvm snd_hda_codec_analog radeon snd_hda_intel mac80211
> coretemp snd_hda_codec kvm_intel kvm snd_hwdep binfmt_misc snd_pcm
> snd_seq_midi iwlwifi snd_rawmidi ttm snd_seq_midi_event cfg80211
> drm_kms_helper pata_pcmcia snd_seq tpm_infineon drm psmouse snd_timer
> joydev pcmcia snd_seq_device snd yenta_socket tpm_tis microcode
> pcmcia_rsrc pcmcia_core ppdev dm_multipath i2c_algo_bit video hp_wmi
> mac_hid sparse_keymap serio_raw soundcore snd_page_alloc lpc_ich wmi
> hp_accel lis3lv02d input_polldev parport_pc lp parport firewire_ohci
> sdhci_pci sdhci firewire_core crc_itu_t e1000e
> [  700.009212] Pid: 2637, comm: bash Not tainted 3.8.4-rc1+ #8

Do you get this same warning on 3.9-rc3?

I thought I got all of the needed fixes for this warning, what am I
missing here?

thanks,

greg k-h
