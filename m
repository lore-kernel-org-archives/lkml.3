Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaIHIjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:39:36 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:49859 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaIHIjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:39:35 -0400
X-Originating-IP: 50.43.15.134
Date: Mon, 8 Sep 2014 01:39:20 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jiri Kosina <trivial@kernel.org>, Huang Shijie <shijie8@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] mtd: denali: fix indentations and other trivial
 things
Message-ID: <20140908083920.GD5361@thin>
References: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
 <1410163813-31783-8-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410163813-31783-8-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 05:10:13PM +0900, Masahiro Yamada wrote:
> @@ -406,9 +404,9 @@ static void get_hynix_nand_para(struct denali_nand_info *denali,
>  		break;
>  	default:
>  		dev_warn(denali->dev,
> -			"Spectra: Unknown Hynix NAND (Device ID: 0x%x)."
> -			"Will use default parameter values instead.\n",
> -			device_id);
> +			 "Spectra: Unknown Hynix NAND (Device ID: 0x%x)."
> +			 "Will use default parameter values instead.\n",
> +			 device_id);

Please join quoted strings into a single line.

> -		pr_err("Your NAND chip OOB is not large enough to \
> -				contain 8bit ECC correction codes");
> +		pr_err("Your NAND chip OOB is not large enough to "
> +		       "contain 8bit ECC correction codes");

Likewise.

- Josh Triplett
