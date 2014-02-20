Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaBTQ7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:59:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47389 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbaBTQ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:59:19 -0500
Message-ID: <53063464.2020602@wwwdotorg.org>
Date: Thu, 20 Feb 2014 09:59:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra124: remove gr2d and gr3d clocks
References: <1392904448-11939-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1392904448-11939-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 06:54 AM, Peter De Schrijver wrote:
> Tegra124 does not have gr2d and gr3d clocks. They have been replaced by the
> vic03 and gpu clocks respectively.

I think you need to remove the DT #defines from
include/dt-bindings/clock/tegra124-car.h too.

With that change made,
Acked-by: Stephen Warren <swarren@nvidia.com>
(I assume this will be sent as a fix for 3.14)
