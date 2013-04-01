Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3DADyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:54:10 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:46301 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756242Ab3DADyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:54:09 -0400
Date: Mon, 1 Apr 2013 09:22:10 +0530
From: Shiraz Hashim <shiraz.hashim@st.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] pwm: mxs: Remove unused *dev from struct
 spear_pwm_chip
Message-ID: <20130401035210.GB21313@localhost.localdomain>
References: <1364784493.7725.1.camel@phoenix>
 <1364784565.7725.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1364784565.7725.2.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

Perhaps you meant pwm: spear: (instead of pwm: mxs) in the subject
line.

On Mon, Apr 01, 2013 at 10:49:25AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-spear.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> index 3223b57..9563599 100644
> --- a/drivers/pwm/pwm-spear.c
> +++ b/drivers/pwm/pwm-spear.c
> @@ -49,13 +49,11 @@
>   * @mmio_base: base address of pwm chip
>   * @clk: pointer to clk structure of pwm chip
>   * @chip: linux pwm chip representation
> - * @dev: pointer to device structure of pwm chip
>   */
>  struct spear_pwm_chip {
>  	void __iomem *mmio_base;
>  	struct clk *clk;
>  	struct pwm_chip chip;
> -	struct device *dev;
>  };
>  
>  static inline struct spear_pwm_chip *to_spear_pwm_chip(struct pwm_chip *chip)
> @@ -200,7 +198,6 @@ static int spear_pwm_probe(struct platform_device *pdev)
>  	if (IS_ERR(pc->clk))
>  		return PTR_ERR(pc->clk);
>  
> -	pc->dev = &pdev->dev;
>  	platform_set_drvdata(pdev, pc);
>  
>  	pc->chip.dev = &pdev->dev;
> -- 
> 1.7.10.4


otherwise,
Acked-by: Shiraz Hashim <shiraz.hashim@st.com>
