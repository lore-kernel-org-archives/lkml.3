Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3AUQ6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:58:47 -0500
Received: from fallback-out2.mxes.net ([216.86.168.191]:23620 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751859Ab3AUQ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:58:45 -0500
X-Greylist: delayed 641 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 11:58:45 EST
Date: Mon, 21 Jan 2013 11:48:02 -0500
From: Brad Tilley <brad@16s.us>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: 3.8.0-rc4 keyboard failure at boot
Message-ID: <20130121164802.GA28285@16s.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Keyboard doesn't work at boot. Users are unable to enter cryptsetup dm-crypt decryption password at boot. 

2. Keyboard fails occasionally on some AMD multi-core systems. Users reboot those systems until the keyboard works. Normally only three to four reboots are required to get a working keyboard. 

2a. The keyboard *always works* on an Intel(R) Celeron(R) CPU 430 @ 1.80GHz. This is true for other single core systems as well. 

2b. The keyboard *never works* on an Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz.

3. Keywords: kernel, cryptsetup, keyboard, dm-crypt

4. Linux version 3.8.0-rc4-bb (rbt@bb) (gcc version 4.4.5 (Debian 4.4.5-8) ) #1 SMP Fri Jan 18 18:50:14 EST 2013

5. No oops message to send.

6. N/A

7. Standard desktop PCs using USB keyboards. Operating system is Debian Linux stable.

7.1 ver_linux from the system where the keyboard always works: 
 
 Linux bb 3.8.0-rc4-bb #1 SMP Fri Jan 18 18:50:14 EST 2013 i686 GNU/Linux
 
 Gnu C                  4.4.5
 Gnu make               3.81
 binutils               2.20.1
 util-linux             ./linux-3.8-rc4/scripts/ver_linux: 23: fdformat: not found
 mount                  support
 module-init-tools      found
 Linux C Library        2.11.3
 Dynamic linker (ldd)   2.11.3
 Procps                 3.2.8
 Kbd                    1.15.2
 Sh-utils               8.5
 Modules Loaded         xfs exportfs libcrc32c xt_state ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack xt_multiport iptable_filter ip_tables x_tables tun sit tunnel4 ppp_generic slhc loop arc4 rt61pci crc_itu_t rt2x00pci rt2x00lib led_class snd_hda_codec_realtek mac80211 snd_hda_intel snd_hda_codec cfg80211 coretemp rfkill snd_hwdep lpc_ich snd_pcm mfd_core snd_timer eeprom_93cx6 snd parport_pc ehci_pci parport i2c_i801 pcspkr soundcore rng_core i2c_core serio_raw processor snd_page_alloc tpm_tis thermal_sys tpm asus_atk0110 microcode tpm_bios button evdev sha256_generic cbc dm_crypt dm_mod sd_mod crc_t10dif ata_generic usb_storage usbhid ata_piix floppy libata piix e1000 uhci_hcd scsi_mod ide_core ehci_hcd atl2

7.2 Intel(R) Celeron(R) CPU 430  @ 1.80GHz (keyboard always works)
    Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz (keyboard never works)

7.3 Can send from kernel 3.7.3 upon request.

7.4 Can send from kernel 3.7.3 upon request.

7.5 Can send from kernel 3.7.3 upon request.

7.6 Can send from kernel 3.7.3 upon request.

7.7 Can send from kernel 3.7.3 upon request.

8. This problem occurs in 3.8.0-rc3 and 3.8.0-rc4. The ver_linux output above is from the computer where the keyboard always works, however the computer with the keyboard that never works runs the same OS (Debian Linux stable), and has the same build tools, very similar kernel config, etc. I'm unable to proceed past cryptsetup/dm-crypt on the computer that always fails with 3.8.0-rc4 (sorry). Kernel 3.7.3 works all the time on all the systems. It never fails. All the systems use dm-crypt/cryptsetup and have encrypted disks. I've updated the BIOS (on the systems they have no working keyboards) to the latest manufacturer version. I've used different keyboards in different USB ports (have not tried a PS2 keyboard). 

Please email me directly if you want more info. I can patch and report back if that would be helpful.

Thanks,

Brad


