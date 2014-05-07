Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaEGRAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:00:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:39350 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751762AbaEGRAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:00:15 -0400
Date: Wed, 7 May 2014 13:00:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ranil Raveendran <ranillal.r@hcl.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: bluez/ofono1.13/ pulseaudio
Message-ID: <20140507130012.0df7d2e8@gandalf.local.home>
In-Reply-To: <91DCB1C9E1DD30478E4BBA849B2C2E6707F0C553@chn-hclt-mbs04.HCLT.CORP.HCL.IN>
References: <91DCB1C9E1DD30478E4BBA849B2C2E6707F0C553@chn-hclt-mbs04.HCLT.CORP.HCL.IN>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Massive WTF!

-- Steve


On Wed, 7 May 2014 16:47:44 +0000
Ranil Raveendran <ranillal.r@hcl.com> wrote:

> Hi All,
> 
> I am using this combination to work with HFP profile. I have gone through many documents and understand that Bluez5 removed the support to HFP profile. Inorder to work with HFP profile we need to make use of Ofono demon which will take care of registering the HFP profile with bluez demon and SCO connection.
> 
> What my problem is very strange.
> 
> I am using bluez5.14  and ofono1.14 demon which is running in my ubuntu mechine.Bluetooth Dongle is connected with ubuntu mechine. Strange thing is dongle adapter path is not listing in ofono demon log.  below is the demon log.
> 
> ofonod[6152]: src/modem.c:ofono_modem_driver_register() driver: 0x8194aa0, name: isiusb
> ofonod[6152]: src/modem.c:ofono_devinfo_driver_register() driver: 0x8194790, name: isimodem
> ofonod[6152]: src/phonebook.c:ofono_phonebook_driver_register() driver: 0x8194780, name: isimodem
> ofonod[6152]: src/network.c:ofono_netreg_driver_register() driver: 0x81947c0, name: isimodem
> ofonod[6152]: src/voicecall.c:ofono_voicecall_driver_register() driver: 0x8194800, name: isimodem
> ofonod[6152]: src/sms.c:ofono_sms_driver_register() driver: 0x8194860, name: isimodem
> ofonod[6152]: src/cbs.c:ofono_cbs_driver_register() driver: 0x8194880, name: isimodem
> ofonod[6152]: src/sim.c:ofono_sim_driver_register() driver: 0x81948a0, name: isimodem
> ofonod[6152]: src/ussd.c:ofono_ussd_driver_register() driver: 0x81948e8, name: isimodem
> ofonod[6152]: src/call-forwarding.c:ofono_call_forwarding_driver_register() driver: 0x8194900, name: isimodem
> ofonod[6152]: src/call-settings.c:ofono_call_settings_driver_register() driver: 0x8194920, name: isimodem
> ofonod[6152]: src/call-barring.c:ofono_call_barring_driver_register() driver: 0x8194950, name: isimodem
> ofonod[6152]: src/call-meter.c:ofono_call_meter_driver_register() driver: 0x8194980, name: isimodem
> ofonod[6152]: src/radio-settings.c:ofono_radio_settings_driver_register() driver: 0x81949c0, name: isimodem
> ofonod[6152]: src/gprs.c:ofono_gprs_driver_register() driver: 0x81949e4, name: isimodem
> ofonod[6152]: src/gprs.c:ofono_gprs_context_driver_register() driver: 0x81949f8, name: isimodem
> ofonod[6152]: src/audio-settings.c:ofono_audio_settings_driver_register() driver: 0x8194a10, name: isimodem
> ofonod[6152]: src/sim.c:ofono_sim_driver_register() driver: 0x8194a20, name: wgmodem2.5
> ofonod[6152]: plugins/udevng.c:udev_start()
> ofonod[6152]: plugins/udevng.c:enumerate_devices()
> ofonod[6152]: plugins/udevng.c:check_usb_device() hub [(null):(null)]
> ofonod[6152]: plugins/udevng.c:check_usb_device() usb [8087:0024]
> ofonod[6152]: plugins/udevng.c:check_usb_device() usb [04ca:0022]
> ofonod[6152]: plugins/udevng.c:check_usb_device() usbhid [(null):(null)]
> ofonod[6152]: plugins/udevng.c:check_usb_device() hub [(null):(null)]
> ofonod[6152]: plugins/udevng.c:check_usb_device() hub [(null):(null)]
> ofonod[6152]: plugins/udevng.c:check_usb_device() usb [8087:0024]
> ofonod[6152]: plugins/udevng.c:check_usb_device() usb [0a12:0001]
> ofonod[6152]: plugins/udevng.c:check_usb_device() btusb [(null):(null)]
> ofonod[6152]: plugins/udevng.c:check_usb_device() btusb [(null):(null)]
> ofonod[6152]: plugins/udevng.c:check_usb_device() usb [(null):(null)]
> ofonod[6152]: plugins/udevng.c:check_usb_device() usb [(null):(null)]
> ofonod[6152]: plugins/udevng.c:check_usb_device() hub [(null):(null)]
> it is waiting after this.
> 
> I have paired my mobile phone with ubuntu mechine. And pairing was succesful and bluez demon listed the new device mac in his log. But there is no communication happening between ofono and bluez5 demon. Not sure Why this is happening i am not sure i am doing any thing wrong.
> 
> But i am not seeing any communication between ofono and bluez , As a result my mobile AG is not listed in the ofono modem list.
> 
> Please help on this......
> 
> I have configured ofofno in /usr/   .... ./configure --enable-test ...    then make ....make install
> 
> Plese let me know why ofono not communication with bluez5
> ________________________________________
> From: linux-kernel-owner@vger.kernel.org [linux-kernel-owner@vger.kernel.org] on behalf of Peter Zijlstra [peterz@infradead.org]
> Sent: Wednesday, May 07, 2014 10:15 PM
> To: Vince Weaver
> Cc: Thomas Gleixner; Ingo Molnar; linux-kernel@vger.kernel.org; Steven Rostedt
> Subject: Re: [perf] more perf_fuzzer memory corruption
> 
> On Tue, May 06, 2014 at 12:57:08PM -0400, Vince Weaver wrote:
> > On Mon, 5 May 2014, Vince Weaver wrote:
> >
> > > On Mon, 5 May 2014, Vince Weaver wrote:
> > >
> > > > Meanwhile the haswell and AMD machines have been fuzzing away without
> > > > issue, I don't know why the core2 machine is always the trouble maker.
> > >
> > > The haswell has been fuzzing 12 hours with only a NMI dazed/confused
> > > message.
> >
> > So the Haswell seemed to still be going strong after 24-hours, but then I
> > killed the fuzzer with control-C and got this.
> >
> > ^C
> > [87536.479011] ------------[ cut here ]------------
> > [87536.484553] WARNING: CPU: 1 PID: 11978 at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
> > [87536.493994] list_del corruption. prev->next should be ffff8800ce684810, but was 6b6b6b6b6b6b6b6b
> > [87536.503915] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp coretemp kvm snd_hda_codec_hdmi crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek snd_hda_codec_generic i915 aesni_intel snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device tpm_tis ppdev snd aes_x86_64 parport_pc tpm evdev mei_me drm_kms_helper iTCO_wdt drm soundcore lrw gf128mul glue_helper iTCO_vendor_support wmi ablk_helper i2c_algo_bit button battery processor mei psmouse parport pcspkr serio_raw cryptd i2c_i801 video i2c_core lpc_ich mfd_core sd_mod sr_mod crc_t10dif cdrom crct10dif_common ahci libahci ehci_pci e1000e libata xhci_hcd ehci_hcd ptp crc32c_intel usbcore scsi_mod pps_core usb_common fan thermal thermal_sys
> > [87536.581372] CPU: 1 PID: 11978 Comm: perf_fuzzer Tainted: G        W     3.15.0-rc1+ #104
> > [87536.590762] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
> > [87536.599435]  0000000000000009 ffff880117b57ad8 ffffffff81649ca0 ffff880117b57b20
> > [87536.608228]  ffff880117b57b10 ffffffff810646ad ffff8800ce684800 ffff880036a64000
> > [87536.616970]  ffff8800ce684810 ffff8800ce684800 0000000000000001 ffff880117b57b70
> > [87536.625688] Call Trace:
> > [87536.629039]  [<ffffffff81649ca0>] dump_stack+0x45/0x56
> > [87536.635247]  [<ffffffff810646ad>] warn_slowpath_common+0x7d/0xa0
> > [87536.642374]  [<ffffffff8106471c>] warn_slowpath_fmt+0x4c/0x50
> > [87536.649211]  [<ffffffff813c9fe1>] __list_del_entry+0xa1/0xd0
> > [87536.655953]  [<ffffffff81131ec4>] list_del_event+0xe4/0xf0
> > [87536.662477]  [<ffffffff811326c0>] perf_remove_from_context+0xb0/0x120
> > [87536.670005]  [<ffffffff81133d8f>] perf_event_release_kernel+0x3f/0x80
> > [87536.677530]  [<ffffffff81133ea3>] put_event+0xd3/0x100
> > [87536.683702]  [<ffffffff81133e00>] ? put_event+0x30/0x100
> > [87536.690047]  [<ffffffff81133ee5>] perf_release+0x15/0x20
> > [87536.696292]  [<ffffffff811b69fc>] __fput+0xdc/0x1e0
> > [87536.702191]  [<ffffffff811b6b4e>] ____fput+0xe/0x10
> > [87536.708038]  [<ffffffff81085154>] task_work_run+0xc4/0xe0
> > [87536.714503]  [<ffffffff81066d5c>] do_exit+0x2cc/0xa50
> > [87536.720546]  [<ffffffff81076949>] ? get_signal_to_deliver+0x249/0x650
> > [87536.728117]  [<ffffffff8106756c>] do_group_exit+0x4c/0xc0
> > [87536.734480]  [<ffffffff81076991>] get_signal_to_deliver+0x291/0x650
> > [87536.741814]  [<ffffffff81012438>] do_signal+0x48/0x990
> > [87536.747877]  [<ffffffff81090c4d>] ? finish_task_switch+0x7d/0x120
> > [87536.754994]  [<ffffffff81651437>] ? _raw_spin_unlock_irq+0x27/0x40
> > [87536.762243]  [<ffffffff81090c4d>] ? finish_task_switch+0x7d/0x120
> > [87536.769465]  [<ffffffff81090c0f>] ? finish_task_switch+0x3f/0x120
> > [87536.776622]  [<ffffffff81012df0>] do_notify_resume+0x70/0xa0
> > [87536.783323]  [<ffffffff81651fbc>] retint_signal+0x48/0x8c
> > [87536.789726] ---[ end trace 2b5a3d32e8d767a7 ]---
> > [87537.231116] ------------[ cut here ]------------
> 
> Of course it did :/ This thing can't ever _just_ work..
> 
> My WSM is playing silly buggers and prefers the endless loop (which you
> saw on Core2 iirc) when I press ^C.
> 
> I'll see if I can make it do something useful.. No immediate ideas
> though.
> 
> 
> ::DISCLAIMER::
> ----------------------------------------------------------------------------------------------------------------------------------------------------
> 
> The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only.
> E-mail transmission is not guaranteed to be secure or error-free as information could be intercepted, corrupted,
> lost, destroyed, arrive late or incomplete, or may contain viruses in transmission. The e mail and its contents
> (with or without referred errors) shall therefore not attach any liability on the originator or HCL or its affiliates.
> Views or opinions, if any, presented in this email are solely those of the author and may not necessarily reflect the
> views or opinions of HCL or its affiliates. Any form of reproduction, dissemination, copying, disclosure, modification,
> distribution and / or publication of this message without the prior written consent of authorized representative of
> HCL is strictly prohibited. If you have received this email in error please delete it and notify the sender immediately.
> Before opening any email and/or attachments, please check them for viruses and other defects.
> 
> ----------------------------------------------------------------------------------------------------------------------------------------------------

