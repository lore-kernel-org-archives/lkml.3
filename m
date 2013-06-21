Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965665Ab3FUGTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:19:35 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54665 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965335Ab3FUGTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:19:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <51B6CF60.9020600@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1369640409-1981-1-git-send-email-pgaikwad@nvidia.com>
 <51A4CA6A.8090103@wwwdotorg.org> <51B6CF60.9020600@nvidia.com>
Message-ID: <20130621061929.9136.10202@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v2] clk: tegra: Use common of_clk_init function
Date: Thu, 20 Jun 2013 23:19:29 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Prashant Gaikwad (2013-06-11 00:18:56)
> On Tuesday 28 May 2013 08:46 PM, Stephen Warren wrote:
> > On 05/27/2013 01:40 AM, Prashant Gaikwad wrote:
> >> Use common of_clk_init() function for clocks initialization.
> 
> Mike,
> 
> Please merge this patch in your tree.

Hi Prashant. I merged this one a long time ago:

Refs: v3.10-rc3-22-g061cec9
Author:     Prashant Gaikwad <pgaikwad@nvidia.com>
AuthorDate: Mon May 27 13:10:09 2013 +0530
Commit:     Mike Turquette <mturquette@linaro.org>
CommitDate: Fri May 31 12:57:25 2013 -0700

Regards,
Mike

> 
> Thanks,
> PrashantG
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
