Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3BWWGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 17:06:05 -0500
Received: from mail-yh0-f63.google.com ([209.85.213.63]:64460 "EHLO
	mail-yh0-f63.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab3BWWGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 17:06:04 -0500
X-Greylist: delayed 21171 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2013 17:06:03 EST
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Sat, 23 Feb 2013 08:04:32 -0800 (PST)
In-Reply-To: <fa.SybVggwovBMN0JQQ1QtgrjYn8OA@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=122.172.37.61;
 posting-account=FuBAQAoAAABC0o4Fb-iG4DiIfKW1QicU
NNTP-Posting-Host: 122.172.37.61
References: <fa.kaJY9QQjCZvkw8CKMyaYEuiX9OA@ifi.uio.no> <fa.5XzmYU8MXZrohXjB0g6dUho0bDk@ifi.uio.no>
 <fa.SybVggwovBMN0JQQ1QtgrjYn8OA@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 122.172.37.61
MIME-Version: 1.0
Message-ID: <fc49612d-d057-4c75-a774-144c06f3e25e@googlegroups.com>
Subject: Re: at91: SAM9G45 doesn't seem to register HDMAC controller anymore
From: hitheshn@gmail.com
To: fa.linux.kernel@googlegroups.com
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys,

Help! I have a similar problem.
SAM9G45 board doesn't seem to load the kernel.
When I see the boot log, it uncompresses the kernel and then just sits there. 

Out of 10 boards, I see this behavior in 2 boards. I tried replacing the DDR RAM first and the CPU itself. But I don't see any change. 
Can you guys help. 
Boot log below - 


-- pico-SAM9G45 Bootstrap 3.0 --

-- AT91SAM9G45-EK

-- Compiled: Jan 27 2011 09:45:18 --

-I- RTC Config: rcen: 1 osc32en: 0 osc32byp: 0 oscsel: 0

-I- RTC Config: rcen: 0 osc32en: 1 osc32byp: 0 oscsel: 1

-I- Setting: MCK = 133MHz

-I- Init DDRAM

-I- Init second bank SDRAM

-I- Loading to 0x70000000

-I- MEDSdcard init

-I- DMAD_Initialize channel 0  

-I- Card Type 2, CSD_STRUCTURE 1

-I- SD/MMC TRANS SPEED 25000 KBit/s

-I- SD 4-BITS BUS

-I- CMD6(2) arg 0x80FFFF01

-I- SD HS Enable

-I- SD/MMC TRANS SPEED 50000 KBit/s

-I- SD/MMC card initialization successful

-I- Card size: 3781 MB

-I- Copy "linux.bin" from SdCard to 0x70000000

-E- File size 2584408 <-> Max allowed size 32

-I- Loading to 0x70107fd0 with size 0x00376f58

-I- MEDSdcard init

-I- DMAD_Initialize channel 0  

-I- Card Type 2, CSD_STRUCTURE 1

-I- SD/MMC TRANS SPEED 25000 KBit/s

-I- SD 4-BITS BUS

-I- CMD6(2) arg 0x80FFFF01

-I- SD HS Enable

-I- SD/MMC TRANS SPEED 50000 KBit/s

-I- SD/MMC card initialization successful

-I- Card size: 3781 MB

-I- Copy "linux.bin" from SdCard to 0x70107fd0

-I- Modified jump to 0x70108010

The board just hangs here.

Thanks
-Hithesh

