Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbaCDKRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:17:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45210 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbaCDKRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:17:16 -0500
Message-ID: <1393928215.3917.6.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v5 2/7] Documentation: of: Document graph bindings
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Tue, 04 Mar 2014 11:16:55 +0100
In-Reply-To: <5310FAE8.5090305@gmail.com>
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>
	 <1393522540-22887-3-git-send-email-p.zabel@pengutronix.de>
	 <5310FAE8.5090305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

Am Freitag, den 28.02.2014, 22:08 +0100 schrieb Sylwester Nawrocki:
> Hi Philipp,
> 
> Just couple minor comments...

Thanks, I'll fix all of those.

> On 02/27/2014 06:35 PM, Philipp Zabel wrote:
> > The device tree graph bindings as used by V4L2 and documented in
> > Documentation/device-tree/bindings/media/video-interfaces.txt contain
> > generic parts that are not media specific but could be useful for any
> > subsystem with data flow between multiple devices. This document
> > describe the generic bindings.
> 
> s/describe/describes/

[...]

> > +These common bindings do not contain any information about the direction of
> 
> s/of/or/ ?

[...]

> > +device_1 {
> > +        port {
> > +                device_1_output: endpoint {
> > +                        remote-endpoint =<&device_2_input>;
> > +                };
> > +        };
> > +};
> > +
> > +device_1 {
> 
> s/device_1/device_2/
> But it might be better to use dashes instead of underscores
> for the node names.

regards
Philipp

