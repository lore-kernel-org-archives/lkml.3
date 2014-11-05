Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaKEWEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:04:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57277 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaKEWED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:04:03 -0500
Date: Wed, 5 Nov 2014 23:03:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141105220359.GA32052@amd>
References: <20141104205117.GA17606@amd>
 <201411052137.31452@pali>
 <20141105203918.GA29199@amd>
 <201411052206.05379@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201411052206.05379@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Maybe you need to enable modem?
> 
> This is n900 init sequence from script: nokia-n900-configs.sh

>From the dts, it looks like this should somehow work without this.

I can try but.. is it safe? I'm using DT-based config, and interrupt
numbers definitely changed. If GPIO numbers changed, it will not be
funny.

Thanks,
									Pavel

>     # set up the GPIO's for N900 modem:
>     echo 70 >/sys/class/gpio/export
>     echo low >/sys/class/gpio/gpio70/direction
>     echo 0 >/sys/class/gpio/gpio70/value
>     echo 73 >/sys/class/gpio/export
>     echo high >/sys/class/gpio/gpio73/direction
>     echo 0 >/sys/class/gpio/gpio73/value
>     echo 74 >/sys/class/gpio/export
>     echo low >/sys/class/gpio/gpio74/direction
>     echo 75 >/sys/class/gpio/export
>     echo low >/sys/class/gpio/gpio75/direction
>     echo 157 >/sys/class/gpio/export
>     echo low >/sys/class/gpio/gpio157/direction
>     echo 0 >/sys/class/gpio/gpio157/value
>     # create symlinks for ofono N900 plugin
>     mkdir -p /dev/cmt
>     ln -nsf /sys/class/gpio/gpio70 /dev/cmt/cmt_apeslpx
>     ln -nsf /sys/class/gpio/gpio74 /dev/cmt/cmt_en
>     ln -nsf /sys/class/gpio/gpio73 /dev/cmt/cmt_rst_rq
>     ln -nsf /sys/class/gpio/gpio75 /dev/cmt/cmt_rst
>     ln -nsf /sys/class/gpio/gpio157 /dev/cmt/cmt_bsi
> 



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
