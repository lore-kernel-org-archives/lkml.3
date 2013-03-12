Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab3CLSxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:53:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47555 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3CLSxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:53:50 -0400
Message-ID: <513F79BA.7000608@wwwdotorg.org>
Date: Tue, 12 Mar 2013 12:53:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-tegra@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: add table lookup to mux
References: <1363113747-6572-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1363113747-6572-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 12:42 PM, Peter De Schrijver wrote:
> Add a table lookup feature to the mux clock. Also allow arbitrary masks
> instead of the width. This will be used by some clocks on Tegra114. Also
> adapt the tegra periph clk because it uses struct clk_mux directly.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> --
> Mike,
> 
> This is the same patch I posted before which implements a table lookup
> feature for the mux clock. I squashed both the changes to clk-mux.c and
> tegra/clk.h together in order to make the patch bisectable.

For the record in this thread, this is a dependency of the Tegra114
clock driver. Can this patch be added to a stable branch in the clk or
arm-soc trees, which I can merge before applying the Tegra114 clock
driver? Thanks.
