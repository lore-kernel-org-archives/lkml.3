Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaIHJPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:15:54 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:39749 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbaIHJPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:15:52 -0400
Date: Mon, 08 Sep 2014 18:14:48 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 7/7] mtd: denali: fix indentations and other trivial things
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jiri Kosina <trivial@kernel.org>, Huang Shijie <shijie8@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140908083920.GD5361@thin>
References: <1410163813-31783-8-git-send-email-yamada.m@jp.panasonic.com> <20140908083920.GD5361@thin>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140908181447.C428.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,


On Mon, 8 Sep 2014 01:39:20 -0700
Josh Triplett <josh@joshtriplett.org> wrote:

> On Mon, Sep 08, 2014 at 05:10:13PM +0900, Masahiro Yamada wrote:
> > @@ -406,9 +404,9 @@ static void get_hynix_nand_para(struct denali_nand_info *denali,
> >  		break;
> >  	default:
> >  		dev_warn(denali->dev,
> > -			"Spectra: Unknown Hynix NAND (Device ID: 0x%x)."
> > -			"Will use default parameter values instead.\n",
> > -			device_id);
> > +			 "Spectra: Unknown Hynix NAND (Device ID: 0x%x)."
> > +			 "Will use default parameter values instead.\n",
> > +			 device_id);
> 
> Please join quoted strings into a single line.
> 
> > -		pr_err("Your NAND chip OOB is not large enough to \
> > -				contain 8bit ECC correction codes");
> > +		pr_err("Your NAND chip OOB is not large enough to "
> > +		       "contain 8bit ECC correction codes");
> 
> Likewise.
> 

Thanks for your review, but
the quoted strings are too long to be joined into a single line.
(exceed 80 columns)


Best Regards
Masahiro Yamada

