Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbaCEOmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:42:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60296 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597AbaCEOmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:42:45 -0500
Message-ID: <1394030554.8754.31.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to
 drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Wed, 05 Mar 2014 15:42:34 +0100
In-Reply-To: <53170C00.20200@ti.com>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
	 <53170C00.20200@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Am Mittwoch, den 05.03.2014, 13:35 +0200 schrieb Tomi Valkeinen:
> Hi,
> 
> On 05/03/14 11:20, Philipp Zabel wrote:
> > Hi,
> > 
> > this version of the OF graph helper move series further addresses a few of
> > Tomi's and Sylwester's comments.
> > 
> > Changes since v5:
> >  - Fixed spelling errors and a wrong device node name in the link section
> >  - Added parentless previous endpoint's full name to warning
> >  - Fixed documentation comment for of_graph_parse_endpoint
> >  - Unrolled for-loop in of_graph_get_remote_port_parent
> > 
> > Philipp Zabel (8):
> >   [media] of: move graph helpers from drivers/media/v4l2-core to
> >     drivers/of
> >   Documentation: of: Document graph bindings
> >   of: Warn if of_graph_get_next_endpoint is called with the root node
> >   of: Reduce indentation in of_graph_get_next_endpoint
> >   [media] of: move common endpoint parsing to drivers/of
> >   of: Implement simplified graph binding for single port devices
> >   of: Document simplified graph binding for single port devices
> >   of: Warn if of_graph_parse_endpoint is called with the root node
> 
> So, as I've pointed out, I don't agree with the API, as it's too limited
> and I can't use it, but as this series is (mostly) about moving the
> current API to a common place, it's fine for me.
> 
> Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

Thanks. I'll be happy to help expanding the API to parse ports
individually, once this gets accepted.

Mauro, Guennadi, are you fine with how this turned out? I'd like to get
your acks again, for the changed location.

regards
Philipp

