Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaCFQvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:51:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34914 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaCFQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:51:13 -0500
Message-ID: <1394124630.3622.64.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to
 drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Thu, 06 Mar 2014 17:50:30 +0100
In-Reply-To: <5318A331.2070603@samsung.com>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
	 <53170C00.20200@ti.com> <1394030554.8754.31.camel@paszta.hi.pengutronix.de>
	 <20140306141657.GB21483@n2100.arm.linux.org.uk>
	 <20140306121721.6186dafb@samsung.com> <5318988C.2030004@samsung.com>
	 <1394122879.3622.47.camel@paszta.hi.pengutronix.de>
	 <5318A331.2070603@samsung.com>
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

Am Donnerstag, den 06.03.2014, 17:32 +0100 schrieb Sylwester Nawrocki:
> On 06/03/14 17:21, Philipp Zabel wrote:
> > Am Donnerstag, den 06.03.2014, 16:47 +0100 schrieb Sylwester Nawrocki:
> >> Yes, it's going to conflict with my patch series. I thought it could be
> >> put onto a stable a topic branch, e.g. at git://linuxtv.org/media_tree.git,
> >> which could be then pulled into the media master branch and anywhere
> >> else it is needed ?
> > 
> > Mauro, are you ok with handling the conflict in the merge, or should I
> > rebase on top of the media tree after you merged Sylwester's changes?
> 
> I could rebase and resolve any conflicts before sending my pull request
> to Mauro. I don't think it's a good idea to rebase this series onto the
> media tree, since it is touching drivers/of.

Excellent, thanks. I will send a pull request to Mauro and Russell
shortly.

regards
Philipp

