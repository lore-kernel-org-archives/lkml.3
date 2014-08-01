Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaHAGbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 02:31:10 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15981 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaHAGbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 02:31:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 31 Jul 2014 23:22:41 -0700
Message-ID: <53DB3428.1060400@nvidia.com>
Date: Fri, 1 Aug 2014 09:31:04 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 8/8] clk: tegra: Add EMC clock driver
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <1405088313-20048-9-git-send-email-mperttunen@nvidia.com> <53CE97F2.80300@wwwdotorg.org> <53D75FA7.1030300@nvidia.com> <20140729201939.4627.79710@quantum> <53D81CD4.5010307@wwwdotorg.org> <20140730093456.GA29590@ulmo> <20140731190659.4463.92139@quantum> <53DA9ED2.5000003@wwwdotorg.org> <20140731230804.4463.12253@quantum>
In-Reply-To: <20140731230804.4463.12253@quantum>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 02:08, Mike Turquette wrote:
> ...
> That is sensible, and all the more reason that this patch shouldn't
> implement the rate-change feature within the clock driver. So consider
> it NAK'd.
>
> Also I agree that the per-clock debugfs entries are very useful for RO
> operations, especially exposing how registers are programmed or other
> relevant data.
>
> Regards,
> Mike
>

Sure, I'll remove the debugfs code from the next version.

Thanks, Mikko
