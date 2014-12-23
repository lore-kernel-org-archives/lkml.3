Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaLWMC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:02:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47237 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbaLWMCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:02:22 -0500
Date: Tue, 23 Dec 2014 13:02:19 +0100
From: Philipp Zabel <pza@pengutronix.de>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel@pengutronix.de
Subject: Re: [PATCH v6 1/3] of: Decrement refcount of previous endpoint in
 of_graph_get_next_endpoint
Message-ID: <20141223120219.GB26129@pengutronix.de>
References: <1419261091-29888-1-git-send-email-p.zabel@pengutronix.de>
 <1419261091-29888-2-git-send-email-p.zabel@pengutronix.de>
 <CANLsYkydZGBQa2KXyVsjp3PaAvfBtOSf+qa0yVdzidJbxcQybw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkydZGBQa2KXyVsjp3PaAvfBtOSf+qa0yVdzidJbxcQybw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:01:45 up 28 days,  3:04, 63 users,  load average: 0,45, 0,50,
 0,43
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 02:09:46PM -0700, Mathieu Poirier wrote:
> On 22 December 2014 at 08:11, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Decrementing the reference count of the previous endpoint node allows to
> > use the of_graph_get_next_endpoint function in a for_each_... style macro.
> > All current users of this function that pass a non-NULL prev parameter
> > (that is, soc_camera and imx-drm) are changed to not decrement the passed
> > prev argument's refcount themselves.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
[...]
> I tested this in my tree - ack.

Thanks!

regards
Philipp
