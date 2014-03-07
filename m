Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaCGMUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:20:45 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:52619 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaCGMUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:20:41 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-9b-5319b997c6c5
Date: Fri, 07 Mar 2014 09:20:31 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
Message-id: <20140307092031.68cd985d@samsung.com>
In-reply-to: <20140307115517.GI21483@n2100.arm.linux.org.uk>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
 <20140307115517.GI21483@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/hIN3pOyWDDa7t4rCYf+Qcq8X7jfOY
	LA782cFocbbpDbtF58Ql7BaXd81hs+jZsJXV4vZlXou7906wWLTuPcJucfhNO6vF+vm32Bx4
	PFqae9g8PnyM85jdMZPVY9OqTjaPO9f2sHn0/zXw6NuyitHj+I3tTB6fN8kFcEZx2aSk5mSW
	pRbp2yVwZcze18ZWsJGjYu33HcwNjJfZuhg5OSQETCTubmtggbDFJC7cWw8U5+IQEljCKLGs
	exYzhNPNJDFh+0GgKg4OFgFViZfTCkAa2ASMJF41trCC2CICphLXHj0Dq2cWOMAs8efXabCE
	sICPROfxm+wgNq+AocTbqw+YQWxOARuJT9N/gNUICRRKTDu2F+oiJ4lXryczQdQLSvyYfA/s
	OmYBLYnN25pYIWx5ic1r3jJPYBSYhaRsFpKyWUjKFjAyr2IULS1OLihOSs811CtOzC0uzUvX
	S87P3cQIiZ2iHYzPNlgdYhTgYFTi4TVYIBEsxJpYVlyZe4hRgoNZSYSXZ7VksBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQZGjXc+H1gC2h5Jr1u98gGvpvyscJX/M2xP5NgxRB5UeiMudiho/ddZ
	ii68ChO+Kr/6YOwm/Vztd1T+1NeZHxz315xdPyvQZFHwOoat65ZOuxf8LjHgG++36fvPTVGu
	NjudH8x7bOuex8pxdoG1oo8bisTyU/tfvQrdwlWt9HO2qf/UjB6pwgxdJZbijERDLeai4kQA
	FYIaQnsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 07 Mar 2014 11:55:17 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> escreveu:

> On Thu, Mar 06, 2014 at 06:13:20PM +0100, Philipp Zabel wrote:
> > Hi Mauro, Russell,
> > 
> > I have temporarily removed the simplified bindings at Sylwester's
> > request and updated the branch with the acks. The following changes
> > since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:
> > 
> >   Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://git.pengutronix.de/git/pza/linux.git topic/of-graph
> 
> Okay, this has all gone wrong.  Mauro has applied your changes as patches,
> and I've pulled this set of changes.  So we're going to be all set for
> merge conflicts....... just fscking great.
> 
> I really don't know why I bother trying to do the right thing sometimes.
> 

I just reverted my tree to the previous state before applying the patches
and did a git pull instead, in order to avoid merge conflicts when the
imx-drm patches arrive via staging tree.

Regards,
Mauro
