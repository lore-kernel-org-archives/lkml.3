Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729Ab3IDCbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:31:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3152 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3IDCbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:31:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Sep 2013 19:31:50 -0700
Message-ID: <52269B92.3070304@nvidia.com>
Date: Wed, 4 Sep 2013 11:31:46 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/5] ARM: tegra: support for Trusted Foundations
References: <1377770268-14014-1-git-send-email-acourbot@nvidia.com> <52262D8F.9060706@wwwdotorg.org>
In-Reply-To: <52262D8F.9060706@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 03:42 AM, Stephen Warren wrote:
> On 08/29/2013 03:57 AM, Alexandre Courbot wrote:
>> New version revised according to comments received for v3. Hopefully
>> it will be good enough to be merged.
>
> Aside from the small issue in patch 1/5, the series,
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Thanks! I have adressed the issues you mentioned and will submit v5 
soon. Despite the fact this adds some non-Tegra stuff, will you be able 
to take it into your tree, or should I ask someone else?
