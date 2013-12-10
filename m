Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab3LJRFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:05:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60514 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3LJRFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:05:19 -0500
Message-ID: <52A749CC.2030402@wwwdotorg.org>
Date: Tue, 10 Dec 2013 10:05:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH V4] dma: add dma_get_any_slave_channel(), for use in of_xlate()
References: <1385494851-22640-1-git-send-email-swarren@wwwdotorg.org> <20131210122224.GK29580@intel.com>
In-Reply-To: <20131210122224.GK29580@intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 05:22 AM, Vinod Koul wrote:
> On Tue, Nov 26, 2013 at 12:40:51PM -0700, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> mmp_pdma.c implements a custom of_xlate() function that is 95% identical
>> to what Tegra will need. Create a function to implement the common part,
>> so everyone doesn't just cut/paste the implementation.
>
> Applied, to topic/of

I assume this one also won't be rebased, so I can merge this into the
Tegra tree as well? Thanks.
