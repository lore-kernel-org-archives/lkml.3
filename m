Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaHATUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:20:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52051 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbaHATUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:20:17 -0400
Message-ID: <53DBE874.7030805@wwwdotorg.org>
Date: Fri, 01 Aug 2014 13:20:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Implement memory-controller clock
References: <1406894945-32069-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1406894945-32069-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 06:09 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> The memory controller clock runs either at half or the same frequency as
> the EMC clock.

Very quickly,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
