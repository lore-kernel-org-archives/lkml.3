Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3AVPl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:41:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab3AVPlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:41:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 09/15] media: coda: don't build on multiplatform
Date: Tue, 22 Jan 2013 15:41:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Javier Martin <javier.martin@vista-silicon.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <1358788568-11137-10-git-send-email-arnd@arndb.de> <20130122082158.GC9414@pengutronix.de>
In-Reply-To: <20130122082158.GC9414@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221541.05636.arnd@arndb.de>
X-Provags-ID: V02:K0:qHh0FiZpWfW2nqKG4nUiGKcg/b9bOHK77Cag+qOFRKy
 yFWHb1O5JnP8tI51fqrKMD++cYvZ2nhW5pGYHEoS4kS+V7byeB
 xkGk+s3OVYKuwAxaGZ4a9DN0kaeFvwfckX7lgRh7u30NU54GiN
 9Nf9cdOJvykLoi1ZNsp0hnuAou0efPONKQrMf6kze0rjmIxqkY
 g5yV84a6TBxnLPW4MHI0FpuSgL7pJaLuy6s6zZ5xiOEnzkRPfj
 9NIanr6dkH962JHZPiVEV91hxDW43hFmtDhFFG9HW8CKcFAmaM
 WHZIcGFLy8ZJbUxRQqm00QxWfg92NbSo6iWKhxAZmFuOQZWKM/
 2BwOiY5FFqSYgP9TEBh0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Sascha Hauer wrote:
> On Mon, Jan 21, 2013 at 05:16:02PM +0000, Arnd Bergmann wrote:
> > The coda video codec driver depends on a mach-imx or mach-mxs specific
> > header file "mach/iram.h". This is not available when building for
> > multiplatform, so let us disable this driver for v3.8 when building
> > multiplatform, and hopefully find a proper fix for v3.9.
> > 
> > drivers/media/platform/coda.c:27:23: fatal error: mach/iram.h: No such file or directory
> 
> I just sent a pull request for this with a proper fix.

Ok, even better. Thanks for taking care of it!

	Arnd
