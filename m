Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaCHFaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:30:22 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:52606 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaCHFaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:30:17 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 1/8] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
In-Reply-To: <1394011242-16783-2-git-send-email-p.zabel@pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> < 1394011242-16783-2-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 07 Mar 2014 18:25:37 +0000
Message-Id: <20140307182537.C2CC5C40B10@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Mar 2014 10:20:35 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> This patch moves the parsing helpers used to parse connected graphs
> in the device tree, like the video interface bindings documented in
> Documentation/devicetree/bindings/media/video-interfaces.txt, from
> drivers/media/v4l2-core/v4l2-of.c into drivers/of/base.c.
> 
> This allows to reuse the same parser code from outside the V4L2
> framework, most importantly from display drivers.
> The functions v4l2_of_get_next_endpoint, v4l2_of_get_remote_port,
> and v4l2_of_get_remote_port_parent are moved. They are renamed to
> of_graph_get_next_endpoint, of_graph_get_remote_port, and
> of_graph_get_remote_port_parent, respectively.
> Since there are not that many current users yet, switch all of
> them to the new functions right away.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

This patch is fine because it only moves code, but I'm not providing an
ack yet.  I'll supply one when I'm happy with the collection of fixups.

g.

