Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaBUOKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:10:44 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:35949 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbaBUOKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:10:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] media: omap3isp: trivial cleanup
Date: Fri, 21 Feb 2014 15:11:56 +0100
Message-ID: <1825367.ljiFnKzG3g@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392984443-16694-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1392984443-16694-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patched.

On Friday 21 February 2014 17:37:20 Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch series include fixing some typos and
> removal of unwanted comments.

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> Lad, Prabhakar (3):
>   media: omap3isp: fix typos
>   media: omap3isp: ispccdc: remove unwanted comments
>   media: omap3isp: rename the variable names in description
> 
>  drivers/media/platform/omap3isp/isp.c        |    2 +-
>  drivers/media/platform/omap3isp/isp.h        |   12 ++++++------
>  drivers/media/platform/omap3isp/ispccdc.c    |   10 +++++-----
>  drivers/media/platform/omap3isp/ispccdc.h    |    6 ------
>  drivers/media/platform/omap3isp/ispccp2.c    |    6 +++---
>  drivers/media/platform/omap3isp/isphist.c    |    4 ++--
>  drivers/media/platform/omap3isp/isppreview.c |   13 +++++++------
>  drivers/media/platform/omap3isp/ispqueue.c   |    2 +-
>  drivers/media/platform/omap3isp/ispresizer.c |    6 +++---
>  drivers/media/platform/omap3isp/ispresizer.h |    4 ++--
>  drivers/media/platform/omap3isp/ispstat.c    |    4 ++--
>  drivers/media/platform/omap3isp/ispvideo.c   |    4 ++--
>  12 files changed, 34 insertions(+), 39 deletions(-)

-- 
Regards,

Laurent Pinchart

