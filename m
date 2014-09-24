Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaIXTnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:43:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56029 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaIXTnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:43:16 -0400
Message-ID: <54231EEC.1080600@wwwdotorg.org>
Date: Wed, 24 Sep 2014 13:43:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
CC: rui.zhang@intel.com, thierry.reding@gmail.com, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, juha-matti.tilli@iki.fi
Subject: Re: [PATCH v5 1/4] of: Add bindings for nvidia,tegra124-soctherm
References: <1408616242-21009-1-git-send-email-mperttunen@nvidia.com> <1408616242-21009-2-git-send-email-mperttunen@nvidia.com> <20140924184054.GA7593@developer>
In-Reply-To: <20140924184054.GA7593@developer>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 12:40 PM, Eduardo Valentin wrote:
> Hello,
>
> On Thu, Aug 21, 2014 at 01:17:19PM +0300, Mikko Perttunen wrote:
>> This adds binding documentation and headers for the Tegra124
>> SOCTHERM device tree node.
>>
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> Acked-by: Stephen Warren <swarren@nvidia.com>
>
> Acked-by: Eduardo Valentin <edubezval@gmail.com>
>
> Stephen, are you still queueing this series in your tree?

Yes, I except it makes sense to take this through the Tegra tree. 
However, it wont' be for 3.18, since I've already sent pull requests for 
this cycle.
