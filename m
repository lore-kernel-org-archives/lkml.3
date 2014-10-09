Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaJIXBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 19:01:00 -0400
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:51110 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751147AbaJIXA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 19:00:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3871:3873:3874:3876:4321:5007:6119:6742:6743:7652:7809:7904:9010:10004:10400:10848:11026:11232:11657:11658:11914:12043:12438:12517:12519:12555:12740:13069:13255:13311:13357:13846:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grain23_5eee917b3c32d
X-Filterd-Recvd-Size: 3212
Message-ID: <1412895651.8770.7.camel@joe-AO725>
Subject: Re: [PATCH V4 6/7] MAINTAINERS: Entry for Cygnus/iproc arm
 architecture and clock drivers
From: Joe Perches <joe@perches.com>
To: Scott Branden <sbranden@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Thu, 09 Oct 2014 16:00:51 -0700
In-Reply-To: <1412894671-5921-7-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
	 <1412894671-5921-1-git-send-email-sbranden@broadcom.com>
	 <1412894671-5921-7-git-send-email-sbranden@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-09 at 15:44 -0700, Scott Branden wrote:
> Acked-by: Jonathan Richardson <jonathar@broadcom.com>
> Signed-off-by: Scott Branden <sbranden@broadcom.com>
> ---
>  MAINTAINERS |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a12edf2..0900082 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2071,9 +2071,24 @@ L:	linux-scsi@vger.kernel.org
>  S:	Supported
>  F:	drivers/scsi/bnx2i/
>  
> -BROADCOM KONA GPIO DRIVER
> +BROADCOM CYGNUS/IPROC ARM ARCHITECTURE
>  M:	Ray Jui <rjui@broadcom.com>
> +M:	Scott Branden <sbranden@broadcom.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  L:	bcm-kernel-feedback-list@broadcom.com
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/arm/bcm/cygnus.txt
> +F:	arch/arm/boot/dts/bcm-cygnus.dtsi
> +F:	arch/arm/boot/dts/bcm911360_entphn.dts
> +F:	arch/arm/configs/bcm_cygnus_defconfig
> +F:	arch/arm/mach-bcm/bcm_cygnus.c
> +F:	Documentation/devicetree/bindings/clock/clk-cygnus.txt
> +F:	Documentation/devicetree/bindings/clock/clk-iproc.txt
> +F:	drivers/clk/bcm/clk-cygnus.c
> +F:	drivers/clk/bcm/clk-iproc.c
> +
> +BROADCOM KONA GPIO DRIVER
> +M:	Ray Jui <rjui@broadcom.com>
>  S:	Supported
>  F:	drivers/gpio/gpio-bcm-kona.c
>  F:	Documentation/devicetree/bindings/gpio/gpio-bcm-kona.txt

This drops this L line from BROADCOM KONA GPIO DRIVER
L:	bcm-kernel-feedback-list@broadcom.com

Is that what you want?

