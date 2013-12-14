Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3LNLYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 06:24:52 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:55552 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3LNLYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 06:24:49 -0500
X-AuditID: cbfec372-b7f366d000002f79-4a-52ac400009a5
Date: Sat, 14 Dec 2013 09:24:43 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: stable regression: tda18271_read_regs: [1-0060|M] ERROR:
 i2c_transfer returned: -19
Message-id: <20131214092443.622b069d@samsung.com>
In-reply-to: <1386969579.3914.13.camel@piranha.localdomain>
References: <1386969579.3914.13.camel@piranha.localdomain>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/hIF0GhzVBBnM2yVu8nbqT3eLyrjls
	Fj0btrJaLNj4iNGBxWPnj+tsHp83yQUwRXHZpKTmZJalFunbJXBlTJrVxFiwXbniw+I7LA2M
	S6W7GDk5JARMJN5f+MEOYYtJXLi3nq2LkYtDSGAJo8TSnS+ZIJxuJomti1qYQapYBFQltmyZ
	zwpiswkYSbxqbAGzRQTUJF51bGABsZkFwiWevFzHCGILCyRJHGlvBbN5BQwl1p2YATaHU8Ba
	Yubce0wgtpCAlcT5/ZuBNnMAXeEksfuAFES5oMSPyfegRmpJbN7WxAphy0tsXvOWeQKjwCwk
	ZbOQlM1CUraAkXkVo2hpcXJBcVJ6rqFecWJucWleul5yfu4mRkigFu1gfLbB6hCjAAejEg/v
	jYWrg4RYE8uKK3MPMUpwMCuJ8CqargkS4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLit0/TQr0vt
	zvf75Q88jt+xy6x0RViIsompiPuya04d/2Ju1R3mZC1eb/lqbV7LqZoct1cit8Ley/5ekXj7
	i9NOn4KK86mTSjsWZZcuN3nfuVswUVU6wWqxPJdxVmbaohMfRC2++dkpbazrvt8+YY7TtqBv
	ZZcvKHv9fDj39cnX0t4ec0qZnyixFGckGmoxFxUnAgAyB+PKMgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 13 Dec 2013 22:19:39 +0100
Frederik Himpe <fhimpe@telenet.be> escreveu:

> [My excuses for multiposting, it seems gmane does not permit posting to all
> the relevant lists]
> 
> Since upgrading my system from Linux 3.12 to 3.12.3, my PCTV Systems
> nanoStick T2 290e does not work anymore.
> 
> This happens with 3.12.3:
> 
> [    3.778817] em28174 #0: i2c eeprom 0000: 26 00 01 00 02 09 d8 85 80 80 e5 80 f4 f5 94 90
> [    3.779741] em28174 #0: i2c eeprom 0010: 78 0d e4 f0 f5 46 12 00 5a c2 eb c2 e8 30 e9 03
> [    3.780643] em28174 #0: i2c eeprom 0020: 12 09 de 30 eb 03 12 09 10 30 ec f1 12 07 72 80
> [    3.781562] em28174 #0: i2c eeprom 0030: ec 00 60 00 e5 f5 64 01 60 09 e5 f5 64 09 60 03
> [    3.782473] em28174 #0: i2c eeprom 0040: c2 c6 22 e5 f7 b4 03 13 e5 f6 b4 87 03 02 09 92
> [    3.783406] em28174 #0: i2c eeprom 0050: e5 f6 b4 93 03 02 07 e6 c2 c6 22 c2 c6 22 12 09
> [    3.784314] em28174 #0: i2c eeprom 0060: cf 02 06 19 1a eb 67 95 13 20 4f 02 c0 13 6b 10
> [    3.785213] em28174 #0: i2c eeprom 0070: a0 1a ba 14 ce 1a 39 57 00 5c 18 00 00 00 00 00
> [    3.786140] em28174 #0: i2c eeprom 0080: 00 00 00 00 44 36 00 00 f0 10 02 00 00 00 00 00
> [    3.787057] em28174 #0: i2c eeprom 0090: 5b 23 c0 00 00 00 20 40 20 80 02 20 01 01 00 00
> [    3.787970] em28174 #0: i2c eeprom 00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [    3.788879] em28174 #0: i2c eeprom 00b0: c6 40 00 00 00 00 a7 00 00 00 00 00 00 00 00 00
> [    3.789790] em28174 #0: i2c eeprom 00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 32
> [    3.790709] em28174 #0: i2c eeprom 00d0: 34 31 30 31 31 36 36 30 31 37 31 32 32 31 46 4b
> [    3.791625] em28174 #0: i2c eeprom 00e0: 4a 31 00 4f 53 49 30 30 33 30 38 44 30 31 31 30
> [    3.792531] em28174 #0: i2c eeprom 00f0: 46 4b 4a 31 00 00 00 00 00 00 00 00 00 00 31 30
> [    3.793444] em28174 #0: i2c eeprom 0100: ... (skipped)
> [    3.793502] em28174 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0xfcf432bb
> [    3.793559] em28174 #0: EEPROM info:
> [    3.793616] em28174 #0: 	microcode start address = 0x0004, boot configuration = 0x01
> [    3.804741] scsi 8:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.82 PQ: 0 ANSI: 0
> [    3.805345] sd 8:0:0:0: Attached scsi generic sg3 type 0
> [    3.818139] em28174 #0: 	No audio on board.
> [    3.818194] em28174 #0: 	500mA max power
> [    3.818247] em28174 #0: 	Table at offset 0x39, strings=0x1aa0, 0x14ba, 0x1ace
> [    3.818318] em28174 #0: Identified as PCTV nanoStick T2 290e (card=78)
> [    3.818374] em28174 #0: v4l2 driver version 0.2.0
> [    3.821522] sd 8:0:0:0: [sdc] Attached SCSI removable disk
> [    3.823606] em28174 #0: V4L2 video device registered as video0
> [    3.823662] em28174 #0: dvb set to isoc mode.
> [    3.823972] usbcore: registered new interface driver em28xx
> [    3.844020] tda18271 1-0060: creating new instance
> [    3.868422] tda18271_read_regs: [1-0060|M] ERROR: i2c_transfer returned: -19
> [    3.868492] Error reading device ID @ 1-0060, bailing out.
> [    3.868548] tda18271_attach: [1-0060|M] error -5 on line 1285
> [    3.868603] tda18271 1-0060: destroying instance
> [    3.868666] Em28xx: Initialized (Em28xx dvb Extension) extension
> [    3.894687] Registered IR keymap rc-pinnacle-pctv-hd
> [    3.894819] input: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/rc/rc0/input23
> [    3.894979] rc0: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/rc/rc0
> [    3.895570] Em28xx: Initialized (Em28xx Input Extension) extension
> 
> I see the same problem reported here:
> https://github.com/Hexxeh/rpi-firmware/issues/38 where it is mentioned
> that this regression also appeared in 3.10 stable series recently.
> 
> I noticed upstream commit 8393796dfa4cf5dffcceec464c7789bec3a2f471
> (media: dvb-frontends: Don't use dynamic static allocation)
> entered both 3.10.22 (which is the first version introducing the
> regression in 3.10 stable according to the linked bug), and 3.12.3.
> This file contains stuff related to tda18271. Could this be the 
> culprit?
> 

Well, for board EM28174_BOARD_PCTV_290E, it first attaches cxd2820r
and then the tuner tda18271.

I suspect that the issue is at cxd2820r. Could you please apply this
patch:
	http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0db3fa2741ad8371c21b3a6785416a4afc0cc1d4 
and see if it solves the issue?

Thanks!
Mauro

-- 

Cheers,
Mauro
