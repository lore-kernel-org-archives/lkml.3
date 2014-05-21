Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaEUG7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:59:03 -0400
Received: from smtp-out-147.synserver.de ([212.40.185.147]:1047 "EHLO
	smtp-out-146.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750954AbaEUG7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:59:01 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20558
Message-ID: <537C4EAB.1040802@metafoo.de>
Date: Wed, 21 May 2014 08:58:51 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Christopher Freeman <cfreeman@nvidia.com>, ldewangan@nvidia.com,
        swarren@nvidia.com, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] Tegra DMA residue improvements
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com> <20140521055213.GK21128@intel.com>
In-Reply-To: <20140521055213.GK21128@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 07:52 AM, Vinod Koul wrote:
> On Tue, May 06, 2014 at 02:22:20PM -0700, Christopher Freeman wrote:
>> A collection of patches to improve Tegra's DMA residual reporting
>>
>> Christopher Freeman (3):
>>    dma: tegra: finer granularity residual for tx_status
>>    dma: tegra: change interrupt-related log levels
>>    dma: tegra: avoid int overflow for transferred count
> Can you pls use the *right* subsystem name...
>

Without you saying what the right subsystem name is, I think it is not that 
obvious what it is:

git log --format="%s" --no-merges drivers/dma/ | grep '^[a-zA-Z]\+' -o | 
sort | uniq -c | sort -n

381 dma
509 dmaengine

So there is a bias towards 'dmaengine', but if you only look at recent 
commits there is a bias towards 'dma'.

git log v3.6..HEAD --format="%s" --no-merges drivers/dma/ | grep 
'^[a-zA-Z]\+' -o | sort | uniq -c | sort -n

181 dmaengine
248 dma

- Lars

