Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967093Ab3E2WmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:42:18 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53233 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966329Ab3E2WmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:42:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <51A442E4.90307@linaro.org>
Cc: kgene.kim@samsung.com, thomas.abraham@linaro.org, patches@linaro.org
References: <1368770153-29041-1-git-send-email-tushar.behera@linaro.org>
 <51A442E4.90307@linaro.org>
Message-ID: <20130529224203.6058.75266@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 0/2] Clock changes for supporting CPUFreq on Exynos5250
Date: Wed, 29 May 2013 15:42:03 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tushar Behera (2013-05-27 22:38:44)
> On 05/17/2013 11:25 AM, Tushar Behera wrote:
> > With the use of common clock framework, CPUFreq driver on EXYNOS5250 now
> > requires a few changes in clocks.
> > 
> > Tested on Exynos5250 based Arndale board.
> > The patches are based on v3.10-rc1.
> > 
> > Tushar Behera (2):
> >   clk: exynos5250: Update cpufreq related clocks for EXYNOS5250
> >   clk: exynos5250: Add sclk_mpll to the parent list of mout_cpu clock
> > 
> >  drivers/clk/samsung/clk-exynos5250.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> 
> Any comments on this series?
> 

I've taken both patches into clk-next.

Regards,
Mike

> -- 
> Tushar Behera
