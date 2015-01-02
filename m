Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbbABMJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 07:09:50 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:36750 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbbABMJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 07:09:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: platform: vsp1: vsp1_hsit:  Remove unused function
Date: Fri, 02 Jan 2015 14:09:58 +0200
Message-ID: <3534952.jhm28o5kMm@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1420134690-993-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420134690-993-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

Thank you for the patch.

On Thursday 01 January 2015 18:51:30 Rickard Strandqvist wrote:
> Remove the function vsp1_hsit_read() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called
> cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

I've taken the patch in my tree and will send a pull request for v3.20.

> ---
>  drivers/media/platform/vsp1/vsp1_hsit.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c
> b/drivers/media/platform/vsp1/vsp1_hsit.c index db2950a..9fb003b 100644
> --- a/drivers/media/platform/vsp1/vsp1_hsit.c
> +++ b/drivers/media/platform/vsp1/vsp1_hsit.c
> @@ -26,11 +26,6 @@
>   * Device Access
>   */
> 
> -static inline u32 vsp1_hsit_read(struct vsp1_hsit *hsit, u32 reg)
> -{
> -	return vsp1_read(hsit->entity.vsp1, reg);
> -}
> -
>  static inline void vsp1_hsit_write(struct vsp1_hsit *hsit, u32 reg, u32
> data) {
>  	vsp1_write(hsit->entity.vsp1, reg, data);

-- 
Regards,

Laurent Pinchart

