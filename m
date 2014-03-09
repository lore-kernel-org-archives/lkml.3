Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaCITWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 15:22:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45457 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaCITWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 15:22:02 -0400
Date: Sun, 9 Mar 2014 20:21:43 +0100
From: Philipp Zabel <pza@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
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
Subject: Re: [PATCH v6 6/8] of: Implement simplified graph binding for single
 port devices
Message-ID: <20140309192143.GB4939@pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
 <1394011242-16783-7-git-send-email-p.zabel@pengutronix.de>
 <20140307183802.B6E90C40C6F@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307183802.B6E90C40C6F@trevor.secretlab.ca>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:13:53 up 197 days,  4:44, 39 users,  load average: 0,35, 0,24,
 0,18
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 06:38:02PM +0000, Grant Likely wrote:
> On Wed,  5 Mar 2014 10:20:40 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > For simple devices with only one port, it can be made implicit.
> > The endpoint node can be a direct child of the device node.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Ergh... I think this is too loosely defined. The caller really should be
> explicit about which behaviour it needs. I'll listen to arguments
> though if you can make a strong argument.

I have dropped this patch and the corresponding documentation patch for
now. This simplification is a separate issue from the move and there is
no consensus yet.
Basically the main issue with the port { endpoint { remote-endpoint=... } }
binding is that it is very verbose if you just need a single link.
Instead of removing the port node, we could also remove the endpoint node
and have the remote-endpoint property direcly in the port node.

regards
Philipp
