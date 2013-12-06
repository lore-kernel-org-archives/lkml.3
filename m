Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3LFGca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:32:30 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13744 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3LFGc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:32:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Dec 2013 22:25:44 -0800
Message-ID: <52A16ECF.4000209@nvidia.com>
Date: Fri, 6 Dec 2013 11:59:35 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 0/4] ARM: tegra: convert dts files of all Tegra platforms
 to use pinctrl defines
References: <1386240249-30786-1-git-send-email-ldewangan@nvidia.com> <52A10D5C.3060002@wwwdotorg.org>
In-Reply-To: <52A10D5C.3060002@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013 05:03 AM, Stephen Warren wrote:
> On 12/05/2013 03:44 AM, Laxman Dewangan wrote:
>> This patch series convert dts files of all Tegra's platforms to use the pinctron
>> dt-binding macro for better readability.
> I think this series looks fine now; I'll apply soon pending what happens
> with the DMA/reset/ binding rework.
>
> There are quite a few typos/spelling/capitalization mistakes in the
> commit descriptions, but I'll fix them up when applying.

Thanks for review. I like to also update the dt binding document to use 
thes macro.
Will post the chnage for doc update also.
And I want to refer this for t124 dt binding doc of pinctrl also.


Thanks,
Laxman
