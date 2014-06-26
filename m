Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbaFZPwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:52:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51754 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbaFZPwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:52:20 -0400
Message-ID: <53AC41B0.40307@wwwdotorg.org>
Date: Thu, 26 Jun 2014 09:52:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: export clock names for debugging
References: <1403797705-26910-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1403797705-26910-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 09:48 AM, Peter De Schrijver wrote:
> When writing a module for testing or debugging purposes, there is no way to
> get hold of clk handles. This patch solves this by exposing all valid clocks
> as clkdev's for the virtual device tegra-clk-debug.

This is to support clk_get_sys()?

I guess this seems fine, so feel free to apply it, but I slightly wonder
why not just include this change as part of the presumably local and
never-to-be-upstreamed test/dev module?
