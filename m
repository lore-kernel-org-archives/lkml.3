Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607Ab3JPK0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:26:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45309 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760583Ab3JPK0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:26:19 -0400
Date: Wed, 16 Oct 2013 11:26:16 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] clk: s3c64xx: Correct spi bus clock hookups
Message-ID: <20131016102616.GG20219@opensource.wolfsonmicro.com>
References: <1381839982-3026-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1785136.Xbc2LARBDy@flatron> <20131016081035.GD20219@opensource.wolfsonmicro.com> <1625192.kcLGqB93c8@amdc1227>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1625192.kcLGqB93c8@amdc1227>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:10:59AM +0200, Tomasz Figa wrote:
> If you have hardware to test this, especially with possibility of checking
> the SPI frequency I would really appreciate this, as I unfortunately don't
> have such.

I might not be able to get around to it this week, but I
certainly should be able to test this on the hardware I have and
measure the SPI speed.

Thanks,
Charles
