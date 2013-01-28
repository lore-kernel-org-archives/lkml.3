Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3A1QuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:50:00 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50526 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3A1Qt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:49:58 -0500
Message-ID: <5106AC31.1040207@wwwdotorg.org>
Date: Mon, 28 Jan 2013 09:49:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] clk: tegra: adapt tegra periph clk to mux table/mask
References: <1359388467-32386-1-git-send-email-pdeschrijver@nvidia.com> <1359388467-32386-3-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1359388467-32386-3-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 08:54 AM, Peter De Schrijver wrote:
> The tegra peripheral clock type uses struct clk_mux directly, so it needs to
> be updated to handle the new mask and table fields. Also the macros need
> to be updated

Just a quick note on patch dependencies here:

Patch 1/2 can presumably be taken through the clk tree whenever Mike is
OK with it.

Patch 2/2 depends on patches in the Tegra tree for 3.9. Since patch 2/2
is useful mostly for the Tegra114 clock driver, and I don't imagine that
will get posted/merged in time for 3.9, it's probably easiest to just
take patch 2/2 for 3.10 along with the Tegra114 clock driver. Also, I
imagine there won't be any more clk/Tegra tree dependencies in 3.10, so
patch 2/2 and the Tegra114 clk driver patches can likely go through the
clk tree itself for 3.10.
