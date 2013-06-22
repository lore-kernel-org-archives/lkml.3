Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3FVO0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 10:26:19 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:56916 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3FVO0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 10:26:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jim Davis <jim.epost@gmail.com>, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: randconfig build errors with next-20130620, in several drivers/media
Date: Sat, 22 Jun 2013 16:26:36 +0200
Message-ID: <2349088.sJtDCiEhsm@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <51C50101.1000300@infradead.org>
References: <20130620185244.GA14176@krebstar.arl.arizona.edu> <5790855.fto4zA3B21@avalon> <51C50101.1000300@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Friday 21 June 2013 18:42:25 Randy Dunlap wrote:
> On 06/21/13 17:27, Laurent Pinchart wrote:
> > On Thursday 20 June 2013 11:52:44 Jim Davis wrote:
> >> Building with the attached random configuration file generates errors in
> >> both
> > 
> > [snip]
> > 
> > The issue seem to be caused by USB_VIDEO_CLASS=y and VIDEO_V4L2=m &&
> > USB=m.
> > I'm not sure what made that combination possible, but I haven't been able
> > to reproduce it locally on next-20130620. Running make with the attached
> > config turns USB_VIDEO_CLASS=y into USB_VIDEO_CLASS=m.
> 
> Yes, same for me:  USB_VIDEO_CLASS=m instead of =y.
> 
> However, please check the attached config file (as reported on June 17).
> 
> On linux-next of 20130621 it still produces:
> 
> CONFIG_USB_VIDEO_CLASS=y
> CONFIG_VIDEO_V4L2=m
> CONFIG_USB=m

I've just sent a patch to linux-media (you've been CC'ed) to fix this.

-- 
Regards,

Laurent Pinchart
