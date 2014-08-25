Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbaHYRlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:41:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40438 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaHYRlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:41:31 -0400
Message-ID: <53FB7564.7020304@wwwdotorg.org>
Date: Mon, 25 Aug 2014 11:41:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, pdeschrijver@nvidia.com
CC: pgaikwad@nvidia.com, mturquette@linaro.org, thierry.reding@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 3/8] ARM: tegra: Add PLL_M_UD and PLL_C_UD to tegra124-car
 binding header
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <1405088313-20048-4-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1405088313-20048-4-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
> Add these clocks to the binding header so that EMC timings that have
> them as parent can refer to the clocks.

Peter, I assume this patch (and patch 4/8 too) will be needed by any EMC 
driver, whether it's part of this series or Tomeu Vizoso's work. Can you 
please review/ack those two patches for later reference. Thanks.
