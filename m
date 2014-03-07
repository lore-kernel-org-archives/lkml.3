Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaCHFa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:30:27 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50793 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaCHFaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:30:18 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 2/8] Documentation: of: Document graph bindings
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
In-Reply-To: <1394011242-16783-3-git-send-email-p.zabel@pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> < 1394011242-16783-3-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 07 Mar 2014 18:27:17 +0000
Message-Id: <20140307182717.67596C40B43@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Mar 2014 10:20:36 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> The device tree graph bindings as used by V4L2 and documented in
> Documentation/device-tree/bindings/media/video-interfaces.txt contain
> generic parts that are not media specific but could be useful for any
> subsystem with data flow between multiple devices. This document
> describes the generic bindings.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

See my comments on the previous version. My concerns are the handling of
the optional 'ports' node and the usage of reverse links.

g.
