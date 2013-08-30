Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3H3K04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:26:56 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:60596 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab3H3K0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:26:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <greg@kroah.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        linux-kernel@vger.kernel.org, m.chehab@samsung.com,
        linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] [media] uvcvideo: quirk PROBE_DEF for Dell SP2008WFP monitor.
Date: Fri, 30 Aug 2013 12:28:16 +0200
Message-ID: <1985123.qJiQ0PhVD2@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130830040021.GA31290@kroah.com>
References: <cover.1377781889.git.joseph.salisbury@canonical.com> <3172143.JtUQzMAjLG@avalon> <20130830040021.GA31290@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thursday 29 August 2013 21:00:21 Greg KH wrote:
> On Fri, Aug 30, 2013 at 02:41:17AM +0200, Laurent Pinchart wrote:
> > On Thursday 29 August 2013 11:17:41 Joseph Salisbury wrote:
> > > BugLink: http://bugs.launchpad.net/bugs/1217957
> > > 
> > > Add quirk for Dell SP2008WFP monitor: 05a9:2641
> > > 
> > > Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> > > Tested-by: Christopher Townsend <christopher.townsend@canonical.com>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > > Cc: linux-media@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: stable@vger.kernel.org
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > I've applied it to my tree. Given that we're too close to the v3.12 merge
> > window I will push it for v3.13.
> 
> A quirk has to wait that long?  That's not ok, they should go in much
> sooner than that...

Can such a patch get merged during the -rc phase ? If so I will push it to 
v3.12.

-- 
Regards,

Laurent Pinchart

