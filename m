Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3IVRx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:53:56 -0400
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:37634 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3IVRxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:53:54 -0400
X-Originating-IP: 83.160.107.163
Date: Sun, 22 Sep 2013 19:51:46 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Joseph <arunjoseph@ti.com>
Subject: Re: [PATCH v2] iio: ti_am335x_adc: Take touchscreen steps into
 account for conversion timeout
Message-ID: <20130922175145.GB27515@raspi>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Cameron <jic23@cam.ac.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Felipe Balbi <balbi@ti.com>,
	Pantelis Antoniou <panto@antoniou-consulting.com>,
	linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
	Arun Joseph <arunjoseph@ti.com>
References: <20130916211749.GG24058@raspi>
 <523D9046.7010305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523D9046.7010305@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El Sat, Sep 21, 2013 at 01:25:42PM +0100 Jonathan Cameron ha dit:

> On 09/16/13 22:17, Matthias Kaehlcke wrote:
> > The calculation of the old conversion timeout value was based on the number of
> > steps used by this driver. This doesn't take into account that other steps
> > can be used by the touchscreen driver. Select the timeout value based on the
> > steps used by both drivers
> > 
> > Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> Looks fine to me but I'd like an Ack from someone more familiar with the device
> if possible.

Arun, do you feel entitled to Ack or can you suggest someone from TI
who is?

> Also, I'm assuming this is a fix we want to push out asap but that isn't
> clear in your patch title.  Perhaps something like:
> 
> iio: ti_am335x_adc: Fix conversion timeout to allow for touch screen steps.
> ?

it's not as critical as it seems as in practice the timeout has the
granularity of a jiffy. If you prefer I still can resend the patch
with the subject you suggest

best regards

-- 
Matthias Kaehlcke
Embedded Linux Developer
Amsterdam

             If God had not intended for us to eat animals,
                  how come He made them out of meat?
                           (Sarah Palin)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
