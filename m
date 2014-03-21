Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbaCUIPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:15:52 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35112 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbaCUIPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:15:42 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <2220569.iDU3Tk3vCh@avalon>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 20140320153804.35d5b835@samsung.com> <20140320231250.8F0E0C412EA@trevor. secretlab.ca> <2220569.iDU3Tk3vCh@avalon>
Date: Fri, 21 Mar 2014 08:15:34 +0000
Message-Id: <20140321081537.472B2C4085E@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 00:26:12 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> On Thursday 20 March 2014 23:12:50 Grant Likely wrote:
> > On Thu, 20 Mar 2014 19:52:53 +0100, Laurent Pinchart wrote:
> > > Then we might not be talking about the same thing. I'm talking about DT
> > > bindings to represent the topology of the device, not how drivers are
> > > wired together.
> > 
> > Possibly. I'm certainly confused now. You brought up the component helpers
> > in drivers/base/component.c, so I thought working out dependencies is part
> > of the purpose of this binding. Everything I've heard so far has given me
> > the impression that the graph binding is tied up with knowing when all of
> > the devices exist.
> 
> The two are related, you're of course right about that.
> 
> We're not really moving forward here. Part of our disagreement comes in my 
> opinion from having different requirements and different views of the problem, 
> caused by experiences with different kind of devices. This is much easier to 
> solve by sitting around the same table than discussing on mailing lists. I 
> would propose a meeting at the ELC but that's still a bit far away and would 
> delay progress by more than one month, which is probably not acceptable.
> 
> I can reply to the e-mail where I've drawn one use case I have to deal with to 
> detail my needs if that can help.
> 
> Alternatively the UK isn't that far away and I could jump in a train if you 
> can provide tea for the discussion :-)

I'm game for that, but it is a long train ride. I'm up in Aberdeen which
is 8 hours from London by train. Also, I'm travelling next week to
California (Collaboration summit), so it will have to be in 2 weeks
time.

Why don't we instead try a Google Hangout or a phone call today.
Anywhere between 11:30 and 14:00 GMT would work for me. I'd offer to
provide the tea, but I haven't quite perfected transporter technology
yet.

g.

