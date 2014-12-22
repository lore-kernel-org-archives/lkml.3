Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaLVRRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:17:05 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42105 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbaLVRRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:17:04 -0500
Date: Mon, 22 Dec 2014 19:16:54 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.19-rc1 v14 1/8] arm: cnx3xxx: Remove spurious default
 for DEBUG_CNS3xxx
Message-ID: <20141222171654.GB6400@tarshish>
References: <1419267445-8330-1-git-send-email-daniel.thompson@linaro.org>
 <1419267572-23981-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419267572-23981-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, Dec 22, 2014 at 04:59:32PM +0000, Daniel Thompson wrote:
> The default value for DEBUG_CNS3XXX appears twice. This patch removes
> the one with the wrong sort order.

In Subject s/cnx3xxx/cns3xxx/

baruch

> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>  arch/arm/Kconfig.debug | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 5ddd4906f7a7..c5648cc1466d 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -1269,7 +1269,6 @@ config DEBUG_UART_PHYS
>  				DEBUG_S3C2410_UART2)
>  	default 0x78000000 if DEBUG_CNS3XXX
>  	default 0x7c0003f8 if FOOTBRIDGE
> -	default 0x78000000 if DEBUG_CNS3XXX
>  	default 0x80010000 if DEBUG_ASM9260_UART
>  	default 0x80070000 if DEBUG_IMX23_UART
>  	default 0x80074000 if DEBUG_IMX28_UART

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
