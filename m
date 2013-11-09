Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab3KIVSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 16:18:14 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:22171 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3KIVSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 16:18:10 -0500
Date: Sat, 9 Nov 2013 22:17:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arnaud Ebalard <arno@natisbad.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: add support for GMT G751 chip in lm75 driver
Message-ID: <20131109221744.488bd9ea@endymion.delvare>
In-Reply-To: <20131109182707.GA19407@roeck-us.net>
References: <87bo1th3ul.fsf@natisbad.org>
	<20131109182707.GA19407@roeck-us.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Nov 2013 10:27:07 -0800, Guenter Roeck wrote:
> On Sat, Nov 09, 2013 at 06:39:14PM +0100, Arnaud Ebalard wrote:
> > 
> > This was tested on a NETGEAR ReadyNAS 2120 device (Marvell Armada XP
> > based board, via DT).
> > 
> > Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
> 
> Looks good. I'll apply it to my -next branch. Since I already sent my 
> pull request to Linus, this will only go in after -rc1, which I hope
> should be ok (unless Jean wants to pick it up for his pull request).

No, I don't.

-- 
Jean Delvare
