Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3FJMRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:17:31 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:54145 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3FJMR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:17:29 -0400
Message-ID: <51B5C3D3.9000609@cogentembedded.com>
Date: Mon, 10 Jun 2013 16:17:23 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
CC: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 14/15] usb: phy: rcar-usb: Fix comment w.r.t. devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-15-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370864113-17895-15-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-06-2013 15:35, Tushar Behera wrote:

> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().

> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: linux-usb@vger.kernel.org
> CC: Felipe Balbi <balbi@ti.com>
> ---
>   drivers/usb/phy/phy-rcar-usb.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/drivers/usb/phy/phy-rcar-usb.c b/drivers/usb/phy/phy-rcar-usb.c
> index a35681b..23c3dd3 100644
> --- a/drivers/usb/phy/phy-rcar-usb.c
> +++ b/drivers/usb/phy/phy-rcar-usb.c
> @@ -161,7 +161,7 @@ static int rcar_usb_phy_probe(struct platform_device *pdev)
>   	 * CAUTION
>   	 *
>   	 * Because this phy address is also mapped under OHCI/EHCI address area,
> -	 * this driver can't use devm_request_and_ioremap(dev, res) here
> +	 * this driver can't use devm_ioremap_resource(dev, res) here
>   	 */
>   	reg0 = devm_ioremap_nocache(dev, res0->start, resource_size(res0));
>   	reg1 = devm_ioremap_nocache(dev, res1->start, resource_size(res1));

     I'm completely removing this comment in my series pushed thru 
renesas.git, so I advise this patch to be ignored not to create conflict 
in the future.

WBR, Sergei

