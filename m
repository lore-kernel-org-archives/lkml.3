Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3GCW2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 18:28:14 -0400
Received: from nm15-vm4.access.bullet.mail.gq1.yahoo.com ([216.39.63.103]:38867
	"EHLO nm15-vm4.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab3GCW2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 18:28:13 -0400
X-Yahoo-Newman-Id: 656520.2089.bm@smtp116.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xauJ9woVM1lcizqJ8yswwPz.20YNCbDsg4UVUG3Jy6npNQX
 Zk.LBDEE1I6.sFMlQOstib8xKBC8EJDvvNnmuBHrAV4EGwSuT5UEaTI7CyyM
 id_.fs49V7.PMp6ces9FocpDGfolLlJTzooHpcwDLzy9lSNvQwdOVGL0Yp.G
 rjF38QgKx1blbma1q0io9ldjKDcRd0mPts5Kr9QQ5zRxnDhKRf_H1XDtgx98
 8cZnOgrKPwm.JSnjDAWxehGtEplGFFVESswqhd6XPXUMRviiAzGtEtxoKq56
 EarPwu9lLbaHl6p0NYFoklE4W0l75vgYtSy.IEqtkgdQdQswjSN5A8hW210u
 1A5VGOAU63J0cvQdSrAPsqDounrI4nMRj6YwjlTTl8NT6Vzkvqii14q3.opm
 weN7Wz52SJ29O7YPEKHTMzeUd3h8cUvHFib7Gdsx0OXTyzvQ26clcWBbWNtu
 0t89BiTSlkqzPdQn3_TXC3UqPIzwI1KQ.RWAPOvBeEnHH_c1UrhykCGeSmGv
 ahR4LDXCW6p3CGBGQgyp92MrXa_0U6AcreQywNMutEUSOYjPJg6RXK5uV059
 AoqZsFw--
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp116.sbc.mail.gq1.yahoo.com with SMTP; 03 Jul 2013 22:28:12 +0000 UTC
Date: Wed, 3 Jul 2013 15:28:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
 X9SRL-F motherboard
Message-ID: <20130703222814.GB32628@roeck-us.net>
References: <002901ce77e9$dfac4f20$9f04ed60$@lucidpixels.com>
 <20130703144201.GA10323@roeck-us.net>
 <007101ce7807$88cfb160$9a6f1420$@lucidpixels.com>
 <20130703163311.GB12506@roeck-us.net>
 <008001ce780d$0d1a79f0$274f6dd0$@lucidpixels.com>
 <20130703171713.GA26555@roeck-us.net>
 <008e01ce7811$b50c9180$1f25b480$@lucidpixels.com>
 <20130703205654.GA30588@roeck-us.net>
 <00ad01ce7830$3b135890$b13a09b0$@lucidpixels.com>
 <00b501ce7830$527362a0$f75a27e0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00b501ce7830$527362a0$f75a27e0$@lucidpixels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 05:00:16PM -0400, Justin Piszcz wrote:
> Re-sending as text.
> 
> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com] 
> Sent: Wednesday, July 03, 2013 5:00 PM
> To: 'Guenter Roeck'
> Cc: linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
> Subject: RE: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
> X9SRL-F motherboard
> 
> 
> 
> -----Original Message-----
> From: Guenter Roeck [mailto:linux@roeck-us.net] 
> Sent: Wednesday, July 03, 2013 4:57 PM
> To: Justin Piszcz
> Cc: linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
> Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
> X9SRL-F motherboard
> 
> [ .. ]
> 
> > 09: 0a 00 00 00 00 0a 0a 0a 0a aa ef 80 ff 40 46 c4 
> > 0a: 0e 01 00 00 ff 00 00 ff 00 00 80 66 66 06 01 01 
>                                                 ^^
> This shows that PECI Agent 0 is supposed to be enabled.
> 
> > Bank 2:
> >     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> > 00: 8c 32 00 01 01 33 01 3c ff 33 ff ff 00 ff ff ff 
>       ^^
> This value suggests that the second temperature sensor (the one creating
> the alarm) is supposed to be the PECI source (which reports the CPU
> temperature
> to the NCT6776), and that it is supposed to be used to control the speed
> of the CPU fan.
>             ^^
> Fan control is in manual mode. Did you set this ?
> It is quite unusual.
> 
> Setting:                
> Current FAN Mode is Optimal.
> Set Fan to Standard Speed
> Set Fan to Full Speed
> Set Fan to Optimal Speed
> 
Maybe that translates into fixed speeds.

Guenter
