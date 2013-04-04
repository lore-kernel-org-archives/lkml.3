Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764432Ab3DDSUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:20:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59575 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764061Ab3DDSUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:20:38 -0400
Message-ID: <515DC473.8000104@wwwdotorg.org>
Date: Thu, 04 Apr 2013 12:20:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Use common of_clk_init() function
References: <1365066351-2395-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1365066351-2395-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 03:05 AM, Prashant Gaikwad wrote:
> Use common of_clk_init() function for clocks initialization.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> ---
> 
> Stephen, if T114 clock series is not going to make in 3.10 then I would
> like Mike to take this patch. If T114 clock series makes it then I have
> to rebase this patch on top of it.

I'm still just hopeful that it the Tegra114 support can get into 3.10;
all I'm waiting on is Mike's ack to apply it. Let's hold off on this
patch until after that. Thanks.
