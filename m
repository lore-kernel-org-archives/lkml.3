Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbaBTR3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:29:43 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45053 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbaBTR3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:29:42 -0500
Message-ID: <53063B82.2070200@wwwdotorg.org>
Date: Thu, 20 Feb 2014 10:29:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Fix vic03 mux index
References: <1392904492-11979-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1392904492-11979-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 06:54 AM, Peter De Schrijver wrote:
> The vic03 mux uses a linear mapping.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

(although I'm not sure why the clock is called vic03 rather than just
vic as it is in the TRM, but that's unrelated to this patch)
