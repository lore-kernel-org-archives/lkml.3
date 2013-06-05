Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3FEQWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:22:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47987 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab3FEQWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:22:35 -0400
Message-ID: <51AF65C8.3030702@wwwdotorg.org>
Date: Wed, 05 Jun 2013 10:22:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: pllp_out2 divider is int only
References: <1370439442-30852-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1370439442-30852-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 07:37 AM, Peter De Schrijver wrote:
> The pllp_out2 should be integer only, the fractional bit should always be 0.

Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
