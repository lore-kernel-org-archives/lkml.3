Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab3BGRt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:49:57 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62669 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759110Ab3BGRt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:49:56 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>, <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1360254640-25831-1-git-send-email-pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-kernel@vger.kernel.org>
References: <1360254640-25831-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130207174949.11471.27667@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: tegra: local arrays should be static
Date: Thu, 07 Feb 2013 09:49:49 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-02-07 08:30:36)
> cclk_g_parents, cclk_lp_parents and sclk_parents are only accessed from within
> clk-tegra30.c. Declare them static to avoid namespace polution.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Acked-by: Mike Turquette <mturquette@linaro.org>
