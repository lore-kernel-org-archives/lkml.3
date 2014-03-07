Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaCGAPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:15:16 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:48900 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaCGAPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:15:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to drivers/of
Date: Fri, 07 Mar 2014 01:16:43 +0100
Message-ID: <3478596.pn1sHUxzAN@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5318988C.2030004@samsung.com>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> <20140306121721.6186dafb@samsung.com> <5318988C.2030004@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Thank you for the patches.

On Thursday 06 March 2014 16:47:24 Sylwester Nawrocki wrote:
> On 06/03/14 16:17, Mauro Carvalho Chehab wrote:
> > Em Thu, 06 Mar 2014 14:16:57 +0000 Russell King - ARM Linux escreveu:
> >>> On Wed, Mar 05, 2014 at 03:42:34PM +0100, Philipp Zabel wrote:
> >>>>> Am Mittwoch, den 05.03.2014, 13:35 +0200 schrieb Tomi Valkeinen:
> >>>>>>> On 05/03/14 11:20, Philipp Zabel wrote:
> >>>>>>>>> Hi,
> >>>>>>>>> 
> >>>>>>>>> this version of the OF graph helper move series further addresses
> >>>>>>>>> a few of Tomi's and Sylwester's comments.
> >>>>>>>>> 
> >>>>>>>>> Changes since v5:
> >>>>>>>>>  - Fixed spelling errors and a wrong device node name in the link
> >>>>>>>>>  section
> >>>>>>>>>  - Added parentless previous endpoint's full name to warning
> >>>>>>>>>  - Fixed documentation comment for of_graph_parse_endpoint
> >>>>>>>>>  - Unrolled for-loop in of_graph_get_remote_port_parent
> >>>>>>>>> 
> >>>>>>>>> Philipp Zabel (8):
> >>>>>>>>>   [media] of: move graph helpers from drivers/media/v4l2-core to
> >>>>>>>>>   drivers/of
> >>>>>>>>>   Documentation: of: Document graph bindings
> >>>>>>>>>   of: Warn if of_graph_get_next_endpoint is called with the root
> >>>>>>>>>   node
> >>>>>>>>>   of: Reduce indentation in of_graph_get_next_endpoint
> >>>>>>>>>   [media] of: move common endpoint parsing to drivers/of
> >>>>>>>>>   of: Implement simplified graph binding for single port devices
> >>>>>>>>>   of: Document simplified graph binding for single port devices
> >>>>>>>>>   of: Warn if of_graph_parse_endpoint is called with the root node
> >>>>>>> 
> >>>>>>> So, as I've pointed out, I don't agree with the API, as it's too
> >>>>>>> limited and I can't use it, but as this series is (mostly) about
> >>>>>>> moving the current API to a common place, it's fine for me.
> >>>>>>> 
> >>>>>>> Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> >>>>> 
> >>>>> Thanks. I'll be happy to help expanding the API to parse ports
> >>>>> individually, once this gets accepted.
> >>>>> 
> >>>>> Mauro, Guennadi, are you fine with how this turned out? I'd like to
> >>>>> get your acks again, for the changed location.
> > 
> > From my side, there's nothing on such code that is V4L2 specific.
> > Moving it to drivers/of makes sense on my eyes.
> > 
> > Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> I'm OK with patches 1...5, 8, so for these:
> 
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

For what it's worth given that you've sent a pull request already, for the 
same patches,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

