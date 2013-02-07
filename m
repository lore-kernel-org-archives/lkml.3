Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab3BGRtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:49:13 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:37593 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759110Ab3BGRtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:49:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>, <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1360255064-28833-1-git-send-email-pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
References: <1360255064-28833-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130207174906.11471.47056@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: tegra: Add missing spinlock for hclk and pclk
Date: Thu, 07 Feb 2013 09:49:06 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-02-07 08:37:35)
> The hclk and pclk clocks are controlled by the same register. Hence a lock is
> required to avoid corruption.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

I assume this is going through the tegra tree with the other ccf
patches, so:

Acked-by: Mike Turquette <mturquette@linaro.org>
