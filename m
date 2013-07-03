Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab3GCU4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:56:54 -0400
Received: from nm6-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.114]:31173
	"EHLO nm6-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933183Ab3GCU4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:56:53 -0400
X-Yahoo-Newman-Id: 87064.40169.bm@smtp108.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: fWbWOfgVM1l_aZbCk072jqIzfb.PevunTvu24K0QDf8ByJ0
 1CD5L0Irbd.7UXkkK0xzsAnhAfVisMOih3_Gf6GAEgjAvPdyLtbl9vQsR6jl
 A4SqMVYzRGMn.gBbb40JsxwyV_3GdoZYzM_lPoUKZN80cnAck.OZtl8hSxot
 5FK8v.H1EuvV2oM_rpvjoNGCosFy3NngDg46NOpzM_TmH0j0CApGn1qu1wjF
 pmnNygQrQQzYtPZE08eZUPOPdDEpHztt15KzpKz0oJf.uHAmMiCxZuFQ4VxX
 HZXhEOHbi6B_PGItC1WnFBkAk_pSk9zQBrN6TAPvTh_ygzDgUe5I9j_bmXa3
 K.heVPdwOE_HD.y4fWGJxGFBF6.HDgDYkWpAubvQe8B.lYmlSRhXyD6iJua2
 1mre9kbqlzfaussBZqO54998HLNhlq4QR3VdbzJyd87dF_Mr7CRpRJcqsvg3
 47djdZvdHoVF0lw2HFZxMi_UQ9SGkn46TfdUCBAoYYz4GMCKYu28YMMbGzEe
 B2mRzE3TXfN7QWguqtL2Sc4DgTIL8k25HuHYPt4C7lC74JZGZUgohN0DFfVS
 5
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp108.sbc.mail.gq1.yahoo.com with SMTP; 03 Jul 2013 13:56:51 -0700 PDT
Date: Wed, 3 Jul 2013 13:56:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
 X9SRL-F motherboard
Message-ID: <20130703205654.GA30588@roeck-us.net>
References: <002901ce77e9$dfac4f20$9f04ed60$@lucidpixels.com>
 <20130703144201.GA10323@roeck-us.net>
 <007101ce7807$88cfb160$9a6f1420$@lucidpixels.com>
 <20130703163311.GB12506@roeck-us.net>
 <008001ce780d$0d1a79f0$274f6dd0$@lucidpixels.com>
 <20130703171713.GA26555@roeck-us.net>
 <008e01ce7811$b50c9180$1f25b480$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008e01ce7811$b50c9180$1f25b480$@lucidpixels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 01:21:06PM -0400, Justin Piszcz wrote:
> 
> 
> -----Original Message-----
> From: Guenter Roeck [mailto:linux@roeck-us.net] 
> Sent: Wednesday, July 03, 2013 1:17 PM
> To: Justin Piszcz
> Cc: linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
> Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
> X9SRL-F motherboard
> 
> [ .. ]
> 
> Can you try http://roeck-us.net/linux/bin/superiotool ?
> 
> Sure, below:
> 
> $ sudo ./superiotool 
> superiotool r4.0-2514-gf419483
> Found Nuvoton WPCM450 (id=0x1a11, rev=0x00) at 0x164e
> Found Nuvoton NCT6776F (C) (id=0xc333) at 0x2e
> $ sudo ./superiotool -V -e
> Probing for Nuvoton Super I/O (sid=0xfc) at 0x164e...
> Found Nuvoton WPCM450 (id=0x1a11, rev=0x00) at 0x164e
> Probing for Nuvoton Super I/O at 0x2e...
> Found Nuvoton NCT6776F (C) (id=0xc333) at 0x2e
> Bank 0:
>     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> 00: 03 33 03 33 00 ff ff ff ff ff ff ff ff ff ff ff 
> 01: 04 ff 00 00 00 00 ff ff 00 00 00 00 00 83 00 00 
> 02: 69 e6 ce ce bc 9e 84 2b ff ff ff ba 43 f9 cb e3 
> 03: ba e3 ba ce a9 ac 8d a8 73 4b 46 ff ff ff ff ff 
> 04: 03 fe 58 ff ff 80 3f ff 2d ff ff ff 10 05 00 a3 
> 05: ff ff ff ff ff ff ff ff c1 ff ff ff ff 01 00 ff 
> 06: 00 ff ff ff ff 01 07 ff ff ff ff ff ff ff ff ff 
> 07: 00 0a 00 21 00 00 00 17 00 ff ff ff ff ff ff ff 
> 08: ff 03 1f 0f ff 3c 3c 3c 00 00 00 00 00 00 00 00 
> 09: 0a 00 00 00 00 0a 0a 0a 0a aa ef 80 ff 40 46 c4 
> 0a: 0e 01 00 00 ff 00 00 ff 00 00 80 66 66 06 01 01 
                                                ^^
This shows that PECI Agent 0 is supposed to be enabled.

> 0b: 00 00 00 00 02 01 35 00 1c 00 00 04 38 c0 c4 ff 
> 0c: 01 00 00 00 00 00 00 00 00 07 02 ff ff ff ff ff 
> 0d: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0e: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0f: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> Bank 1:
>     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> 00: 82 00 00 01 01 28 01 3c ff 33 ff ff 00 ff ff ff 
> 01: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 02: 01 23 28 37 37 ff ff 28 51 ff ff ff ff ff ff ff 
> 03: ff 00 ff ff 00 55 ff ff 05 01 00 00 00 00 00 00 
> 04: ff ff ff ff ff d9 03 ff ff ff ff ff ff ff 01 ff 
> 05: 00 00 00 5c 00 5f 00 ff ff ff ff ff ff ff ff ff 
> 06: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 07: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 08: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 09: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0a: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0b: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0c: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0d: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0e: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0f: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> Bank 2:
>     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> 00: 8c 32 00 01 01 33 01 3c ff 33 ff ff 00 ff ff ff 
      ^^
This value suggests that the second temperature sensor (the one creating
the alarm) is supposed to be the PECI source (which reports the CPU temperature
to the NCT6776), and that it is supposed to be used to control the speed
of the CPU fan.
            ^^
Fan control is in manual mode. Did you set this ?
It is quite unusual.

> 01: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 02: 01 32 5a 5a 5a ff ff 33 ff ff ff ff ff ff ff ff 
> 03: ff 00 ff ff 00 5f ff ff 03 01 00 00 00 00 00 00 
> 04: ff ff ff ff ff 2c 05 ff ff ff ff ff ff ff 02 ff 
> 05: 21 00 00 5c 00 5f 00 ff ff ff ff ff ff ff ff ff 
> 06: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 07: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 08: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 09: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0a: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0b: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0c: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0d: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0e: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0f: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> Bank 3:
>     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> 00: 03 00 00 0a 0a 01 01 3c ff ff ff ff 00 ff ff ff 
> 01: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 02: 00 19 23 2d 37 ff ff 8c aa c8 e6 ff ff ff ff ff 
> 03: ff 00 ff ff 00 3c ff ff 00 01 00 00 00 00 00 00 
> 04: ff ff ff ff ff 48 04 ff ff ff ff ff ff ff 03 ff 
> 05: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 06: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 07: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 08: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 09: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0a: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0b: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0c: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0d: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0e: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0f: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> Bank 4:
>     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> 00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> 01: 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff ff 
> 02: ff ff ff 96 64 96 64 e1 96 ff ff ff ff ff ff ff 
> 03: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 04: 3f 00 03 ff ff ff ff ff ff ff ff ff ff ff 04 ff 
> 05: 31 13 ff ff 00 00 00 ff 00 20 12 00 09 ff ff ff 
> 06: ff 01 00 00 00 00 00 00 ff ff ff ff ff ff ff ff 
> 07: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 08: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 09: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0a: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0b: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0c: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0d: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0e: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0f: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> Bank 5:
>     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> 00: ff ff 00 00 00 00 ff ff ff ff ff ff ff 00 00 ff 
> 01: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 02: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 03: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 04: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 05 ff 
> 05: df d9 c0 ff e3 ba e3 a9 ff ff ff ff ff ff ff ff 
> 06: 00 00 00 00 00 00 07 01 01 ff ff ff ff ff ff ff 
> 07: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 08: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 09: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0a: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0b: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0c: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0d: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0e: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0f: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> Bank 6:
>     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> 00: 00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 01: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 02: ff 01 0c 02 03 01 01 ff 00 00 00 17 2b 2b 00 ff 
> 03: 2a 1a 1f 1c 26 0f 26 1f 2a 04 3c 06 3c 06 3c 06 
> 04: 3c 06 3c 06 02 02 02 ff ff ff ff ff ff ff 06 ff 
> 05: 7f 7f 7f 7f 7f 7f 03 d9 05 2b 04 48 04 3a 03 e9 
> 06: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 07: 7f 7f 50 4b 04 7f 7f 50 4b 04 7f 7f 50 4b 04 ff 
> 08: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 09: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0a: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0b: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0c: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0d: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0e: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0f: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> Bank 7:
>     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> 00: ff 95 02 10 00 00 00 00 00 64 00 00 00 00 00 00 
> 01: 00 00 00 00 00 00 00 f8 80 f8 80 f8 80 f8 80 00 
                                                   ^^
00 here shows that the PECI source is not active, ie the CPU does not deliver
PECI data to the NCT6776. This explains the alarm.

Practical impact is probably limited as fan control is configured to be manual
anyway, but I wonder why PECI doesn't work on your board. PECI configuration
is identical to my Supermicro board.

Guenter

> 02: 28 00 06 00 00 09 00 00 00 ef 00 00 00 00 00 00 
> 03: 00 00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 04: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 07 ff 
> 05: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 06: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 07: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 08: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 09: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0a: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0b: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0c: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0d: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0e: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> 0f: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> Probing for Nuvoton Super I/O at 0x4e...
>   Failed. Returned data: chip_id=0xffff
> Probing for Nuvoton Super I/O (sid=0xfc) at 0x4e...
> 
> 
> > [ .. ]
> > 
> > You have to specify the raw attribute names, not the symbolic ones.
> > You see the raw attribute names with "sensors -u".
> > 
> It has to be
> 	ignore temp8
> 	ignore temp9
> 	ignore temp10
> 
> Woohoo! Thank you.
> 
> nct6776-isa-0a30
> Adapter: ISA adapter
> Vcore:        +0.83 V  (min =  +0.54 V, max =  +1.49 V)
> in1:          +1.85 V  (min =  +1.62 V, max =  +1.99 V)
> AVCC:         +3.30 V  (min =  +2.98 V, max =  +3.63 V)
> +3.3V:        +3.28 V  (min =  +2.98 V, max =  +3.63 V)
> in4:          +1.50 V  (min =  +1.35 V, max =  +1.65 V)
> in5:          +1.26 V  (min =  +1.13 V, max =  +1.38 V)
> in6:          +1.06 V  (min =  +0.92 V, max =  +1.34 V)
> 3VSB:         +3.57 V  (min =  +2.98 V, max =  +3.63 V)
> Vbat:         +3.47 V  (min =  +2.70 V, max =  +3.63 V)
> fan1:        1010 RPM  (min =  700 RPM)
> fan2:        1324 RPM  (min =  700 RPM)
> fan3:        1102 RPM  (min =  700 RPM)
> fan4:        1062 RPM  (min =  700 RPM)
> fan5:         991 RPM  (min =  700 RPM)
> SYSTIN:       +43.0 C  (high = +75.0 C, hyst = +70.0 C)  sensor = thermistor
> CPUTIN:       +33.0 C  (high = +95.0 C, hyst = +92.0 C)  ALARM  sensor =
> thermistor
> AUXTIN:       +23.0 C  (high = +80.0 C, hyst = +75.0 C)  sensor = thermistor
> 
> Justin.
> 
> 
> 
