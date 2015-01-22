Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbbAVVuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:50:13 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:60533 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbbAVVuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:50:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?= <niso@kth.se>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH v2 1/4] sh-pfc: add macro to define pinmux without function
Date: Thu, 22 Jan 2015 23:50:41 +0200
Message-ID: <1580306.72ms5WNCEt@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1421583604-27256-2-git-send-email-niso@kth.se>
References: <1421583604-27256-1-git-send-email-niso@kth.se> <1421583604-27256-2-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Sunday 18 January 2015 13:20:01 Niklas Söderlund wrote:
> Used to define pinmux configurations where the pinmux function have no
> representation in the configuration registers but instead solely depends
> on a group selection.
> 
> Signed-off-by: Niklas Söderlund <niso@kth.se>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/pinctrl/sh-pfc/sh_pfc.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pinctrl/sh-pfc/sh_pfc.h
> b/drivers/pinctrl/sh-pfc/sh_pfc.h index 5b72831..c837286 100644
> --- a/drivers/pinctrl/sh-pfc/sh_pfc.h
> +++ b/drivers/pinctrl/sh-pfc/sh_pfc.h
> @@ -167,6 +167,8 @@ struct sh_pfc_soc_info {
>  	PINMUX_DATA(fn##_MARK, FN_##fn, FN_##ipsr)
>  #define PINMUX_IPSR_NOGM(ispr, fn, ms)					\
>  	PINMUX_DATA(fn##_MARK, FN_##fn, FN_##ms)
> +#define PINMUX_IPSR_NOFN(ipsr, fn, ms)					\
> +	PINMUX_DATA(fn##_MARK, FN_##ipsr, FN_##ms)
>  #define PINMUX_IPSR_MSEL(ipsr, fn, ms)					\
>  	PINMUX_DATA(fn##_MARK, FN_##fn, FN_##ipsr, FN_##ms)
>  #define PINMUX_IPSR_MODSEL_DATA(ipsr, fn, ms)				\

-- 
Regards,

Laurent Pinchart

