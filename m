Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3AUKDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:03:34 -0500
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3806 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3AUKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:03:33 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 05:03:33 EST
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: tvp514x: remove field description
Date: Mon, 21 Jan 2013 10:56:09 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
References: <1358236540-2091-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1358236540-2091-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211056.09244.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue January 15 2013 08:55:40 Lad, Prabhakar wrote:
> This patch removes the field description of fields that no
> longer exists, along side aligns the field description of
> fields.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  include/media/tvp514x.h |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/include/media/tvp514x.h b/include/media/tvp514x.h
> index 74387e8..86ed7e8 100644
> --- a/include/media/tvp514x.h
> +++ b/include/media/tvp514x.h
> @@ -96,12 +96,9 @@ enum tvp514x_output {
>  
>  /**
>   * struct tvp514x_platform_data - Platform data values and access functions.
> - * @power_set: Power state access function, zero is off, non-zero is on.
> - * @ifparm: Interface parameters access function.
> - * @priv_data_set: Device private data (pointer) access function.
>   * @clk_polarity: Clock polarity of the current interface.
> - * @ hs_polarity: HSYNC Polarity configuration for current interface.
> - * @ vs_polarity: VSYNC Polarity configuration for current interface.
> + * @hs_polarity: HSYNC Polarity configuration for current interface.
> + * @vs_polarity: VSYNC Polarity configuration for current interface.
>   */
>  struct tvp514x_platform_data {
>  	/* Interface control params */
> 
