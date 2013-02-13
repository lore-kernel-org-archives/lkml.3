Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab3BMKjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:39:20 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:27110 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3BMKjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:39:18 -0500
Date: Wed, 13 Feb 2013 11:39:06 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: MAINTAINERS: Remove Mark M. Hoffman
Message-ID: <20130213113906.789a30f2@endymion.delvare>
In-Reply-To: <20130212164601.c348b670.akpm@linux-foundation.org>
References: <20130208105437.347ea5b4@endymion.delvare>
	<20130212164601.c348b670.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 16:46:01 -0800, Andrew Morton wrote:
> On Fri, 8 Feb 2013 10:54:37 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Mark M. Hoffman stopped working on the Linux kernel several years
> > ago, so he should no longer be listed as a driver maintainer. I'm not
> > even sure if his e-mail address still works.
> > 
> > I can take over 3 drivers he was responsible for, the 4th one will
> > fall down to the subsystem maintainer.
> 
> It's nice to give developers a mention in ./CREDITS if we're to expunge
> them from ./MAINTAINERS.  Something like this?
> 
> --- a/CREDITS~maintainers-remove-mark-m-hoffman-fix
> +++ a/CREDITS
> @@ -1510,6 +1510,11 @@ D: Natsemi ethernet
>  D: Cobalt Networks (x86) support
>  D: This-and-That
>  
> +N: Mark M. Hoffman
> +E: mhoffman@lightlink.com
> +D: Maintenance of drivers/hwmon/asb100.c, drivers/i2c/busses/i2c-sis96x.c
> +D: i2c core contributions
> +
>  N: Dirk Hohndel
>  E: hohndel@suse.de
>  D: The XFree86[tm] Project

Mark did more than this. He actually wrote the asb100 and i2c-sis96x
drivers, and also the i2c-stub, lm93, smsc47b397 and core hwmon
drivers. He has also been the hwmon subsystem maintainer for one year.

OTOH I do not remember significant contributions from him to the i2c
core.

I'll send a version 2 of the patch.

-- 
Jean Delvare
