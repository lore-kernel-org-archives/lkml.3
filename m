Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaJ0Rqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:46:32 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:47584 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaJ0Rqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:46:31 -0400
Date: Mon, 27 Oct 2014 18:43:20 +0100
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v3 00/47] kernel: Add support for power-off handler call
 chain
Message-ID: <20141027174320.GI2006@localhost>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <20141027160324.GD10814@saruman>
 <20141027171617.GA19379@roeck-us.net>
 <20141027173310.GB16005@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027173310.GB16005@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 12:33:10PM -0500, Felipe Balbi wrote:
> On Mon, Oct 27, 2014 at 10:16:17AM -0700, Guenter Roeck wrote:
> > On Mon, Oct 27, 2014 at 11:03:24AM -0500, Felipe Balbi wrote:
> > > Adding Johan, who's working on RTC power off for AM335x devices
> > > 
> > Hi Felipe,
> > 
> > is that the rtc-omap driver ?
> 
> yes it is.
> 
> > I am tracking linux-next for related changes. As new power-off handlers are
> > introduced, I prepare patches for those as well. I currently have patches for
> > the following two drivers in the queue:
> > 	drivers/regulator/act8865-regulator.c
> > 	drivers/rtc/rtc-omap.c
> > 
> > I plan to send review requests for those patches in a week or so (I think
> > there is still some change pending to the power-off function in the rtc-omap
> > driver, and I want to wait for it).
> 
> yeah, Johan's working on that.

It's finished. I just sent the final version to akpm this morning
(adding a single mdelay), so you should be fine basing any conversion on
either v2 (in mmotm) or v3.

Johan
