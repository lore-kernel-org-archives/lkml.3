Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaCHFhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:37:53 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59053 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaCHFaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:30:18 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <530EF914.3000407@ti.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>	 < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>	 < 20140217181451.7EB7FC4044D@trevor.secretlab.ca>	 <20140218070624.GP17250@ pengutronix.de>	 <20140218162627.32BA4C40517@trevor.secretlab.ca>	 < 1393263389.3091.82.camel@pizza.hi.pengutronix.de>	 <20140226110114. CF2C7C40A89@trevor.secretlab.ca> <1393426129.3248.64.camel@paszta.hi. pengutronix.de> <530EF914.3000407@ti.com>
Date: Sat, 08 Mar 2014 01:06:45 +0800
Message-Id: <20140307170645.CE50DC40A1B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 10:36:36 +0200, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 26/02/14 16:48, Philipp Zabel wrote:
> 
> >> I would like the document to acknowledge the difference from the
> >> phandle+args pattern used elsewhere and a description of when it would
> >> be appropriate to use this instead of a simpler binding.
> > 
> > Alright. The main point of this binding is that the devices may have
> > multiple distinct ports that each can be connected to other devices.
> 
> The other main point with this binding are multiple endpoints per port.
> So you can have, say, a display controller, with single port, which has
> two endpoints going to two separate LCD panels.
> 
> In physical level that would usually mean that the same pins from the
> display controller are connected to two panels. Most likely this would
> mean that only one panel can be used at a time, possibly with different
> settings (say, 16 RGB pins for one panel, 24 RGB pins for the other).

What device is in control in that scenario?

g.
