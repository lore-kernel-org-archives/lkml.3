Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3GQMUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:20:47 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:32926 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3GQMUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:20:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Davinci VPBE use devres and some cleanup
Date: Wed, 17 Jul 2013 14:21:29 +0200
Message-ID: <2425805.RBpmei1UGe@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Saturday 13 July 2013 14:20:26 Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch series replaces existing resource handling in the
> driver with managed device resource.

Thank you for the patches. They greatly simplify the probe/remove functions, I 
like that. For patches 1 to 4,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I have the same concern as Joe Perches for patch 5.

> Lad, Prabhakar (5):
>   media: davinci: vpbe_venc: convert to devm_* api
>   media: davinci: vpbe_osd: convert to devm_* api
>   media: davinci: vpbe_display: convert to devm* api
>   media: davinci: vpss: convert to devm* api
>   media: davinci: vpbe: Replace printk with dev_*
> 
>  drivers/media/platform/davinci/vpbe.c         |    6 +-
>  drivers/media/platform/davinci/vpbe_display.c |   23 ++----
>  drivers/media/platform/davinci/vpbe_osd.c     |   45 +++---------
>  drivers/media/platform/davinci/vpbe_venc.c    |   97  ++++-----------------
>  drivers/media/platform/davinci/vpss.c         |   62 ++++------------
>  5 files changed, 52 insertions(+), 181 deletions(-)

-- 
Regards,

Laurent Pinchart

