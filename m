Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbaCTSsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:48:50 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35458 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759669AbaCTSss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:48:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Thu, 20 Mar 2014 19:50:35 +0100
Message-ID: <13435143.OQHHLITVrH@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140320181820.GY7528@n2100.arm.linux.org.uk>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <2161777.L3ZZmhyfM4@avalon> <20140320181820.GY7528@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Thursday 20 March 2014 18:18:20 Russell King - ARM Linux wrote:
> On Thu, Mar 20, 2014 at 07:16:29PM +0100, Laurent Pinchart wrote:
> > On Thursday 20 March 2014 17:54:31 Grant Likely wrote:
> > > On Wed, 12 Mar 2014 10:25:56 +0000, Russell King - ARM Linux wrote:

[snip]

> > > > I believe trying to do this according to the flow of data is just
> > > > wrong. You should always describe things from the primary device for
> > > > the CPU towards the peripheral devices and never the opposite
> > > > direction.
> > > 
> > > Agreed.
> > 
> > Absolutely not agreed. The whole concept of CPU towards peripherals only
> > makes sense for very simple devices and breaks as soon as the hardware
> > gets more complex. There's no such thing as CPU towards peripherals when
> > peripherals communicate directly.
> > 
> > Please consider use cases more complex than just a display controller and
> > an encoder, and you'll realize how messy not being able to parse the
> > whole graph at once will become. Let's try to improve things, not to make
> > sure to prevent support for future devices.
> 
> That's odd, I did.
> 
> Please draw some (ascii) diagrams of the situations you're saying this
> won't work for, because at the moment all I'm seeing is some vague
> hand-waving rather than anything factual that I can relate to.  Help
> us to actually _see_ the problem you have with this approach so we can
> understand it.

Working on it. Given my drawing skills this will take a bit of time.

-- 
Regards,

Laurent Pinchart

