Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaG2QSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:18:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38174 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaG2QSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:18:53 -0400
Message-ID: <53D7C96E.8090307@wwwdotorg.org>
Date: Tue, 29 Jul 2014 10:18:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Implement memory-controller clock
References: <1406643437-15682-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1406643437-15682-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 08:17 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> The memory controller clock runs either at half or the same frequency as
> the EMC clock.

The changes to *.c look basically identical. Is there a shared file 
where the MC clock can be defined to avoid duplication?

Other than that, this looks fine at a brief glance.
