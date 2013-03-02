Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3CCJWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:22:54 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48667 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3CCJWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:22:51 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: tegra: assume CONFIG_OF
To: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
In-Reply-To: <1360965288-14899-1-git-send-email-swarren@wwwdotorg.org>
References: <1360965288-14899-1-git-send-email-swarren@wwwdotorg.org>
Date: Sat, 02 Mar 2013 09:34:10 +0000
Message-Id: <20130302093410.42C193E2137@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 14:54:48 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Tegra only supports, and always enables, device tree. Remove all ifdefs
> and runtime checks for DT support from the driver.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Applied, thanks.

g.

