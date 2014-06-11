Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaFKCEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:04:47 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:49193 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbaFKCEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:04:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140610200549.GW22347@spo001.leaseweb.com>
References: <20140610200549.GW22347@spo001.leaseweb.com>
Date: Tue, 10 Jun 2014 19:04:44 -0700
Message-ID: <CAADWXX_U7PsJ7J8zks8yB4KiVd3TfdH9g2tn7pD_4R0ZGOvYEw@mail.gmail.com>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.16 merge window
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tang Yuantian <yuantian.tang@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>, Anatolij Gustschin <agust@denx.de>,
        Xiubo Li <Li.Xiubo@freescale.com>, Gabor Juhos <juhosg@openwrt.org>,
        Alexander Shiyan <shc_work@mail.ru>,
        gundberg <per.gundberg@icomera.com>,
        =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jean Delvare <jdelvare@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 1:05 PM, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Linus,
>
> Please pull from 'master' branch of
>         git://www.linux-watchdog.org/linux-watchdog.git

gmail has decided that you are a spammer, and the only reason I saw
this email was that BenH had the same fate and emailed me from another
account to check.

You and BenH have something in common: no SPF records. That tends to
be one of the things that makes gmail unhappy, and look closer at
emails and make it more likely to consider things spam:

  Received-SPF: none (google.com: wimvs@spo001.leaseweb.com does not
designate permitted sender hosts) client-ip=83.149.101.17;
  Authentication-Results: mx.google.com;
         spf=neutral (google.com: wimvs@spo001.leaseweb.com does not
designate permitted sender hosts) smtp.mail=wimvs@spo001.leaseweb.com

Anyway, no need to resend since I found it, but you might want to talk
to your email provider about your SPF records...

               Linus
