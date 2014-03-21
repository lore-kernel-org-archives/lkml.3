Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbaCUOdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:33:14 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:63615 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbaCUOdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:33:11 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <532C2D94.4020705@ti.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 139468148.3QhLg3QYq1@avalon> <531F08A8.300@ti.com> <1883687.VdfitvQEN3@ samsung.com> <avalon@samsung.com> <20140320172302.CD320C4067A@trevor. secretlab.ca> <532C1808.6090409@samsung.com> <20140321114735.3E132C4052A@ trevor.secretlab.ca> <532C2D94.4020705@ti.com>
Date: Fri, 21 Mar 2014 14:33:04 +0000
Message-Id: <20140321143304.D62ADC405B0@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 14:16:20 +0200, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 21/03/14 13:47, Grant Likely wrote:
> 
> > I'm firm on the opinion that the checking must also happen at runtime.
> > The biggest part of my objection has been how easy it would be to get a
> > linkage out of sync, and dtc is not necessarily the last tool to touch
> > the dtb before the kernel gets booted. I want the kernel to flat out
> > reject any linkage that is improperly formed.
> 
> Isn't it trivial to verify it with the current v4l2 bindings? And
> endpoint must have a 'remote-endpoint' property, and the endpoint on the
> other end must have similar property, pointing in the first endpoint.
> Anything else is an error.
> 
> I agree that it's easier to write bad links in the dts with
> double-linking than with single-linking, but it's still trivial to
> verify it in the kernel.

Right, which is exactly what I'm asking for.

g.

