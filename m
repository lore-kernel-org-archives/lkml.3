Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaKYGAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 01:00:22 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:17960 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750841AbaKYGAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 01:00:20 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43932096"
Message-ID: <54740A30.8020105@cn.fujitsu.com>
Date: Tue, 25 Nov 2014 12:48:48 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: <kmo@daterainc.com>, <akpm@linux-foundation.org>, <dm-devel@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <drbd-user@lists.linbit.com>
Subject: Re: [PATCH 0/6] blk: introduce generic io stat accounting help function
References: <1416798327-12817-1-git-send-email-guz.fnst@cn.fujitsu.com> <547348DE.60704@kernel.dk>
In-Reply-To: <547348DE.60704@kernel.dk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 11:03 PM, Jens Axboe wrote:

> On 11/23/2014 08:05 PM, Gu Zheng wrote:
>> Many block drivers accounting io stat based on bio (e.g. NVMe...),
>> the blk_account_io_start/end() which is based on request
>> does not make sense to them, so here we introduce the similar help
>> function named generic_start/end_io_acct base on raw sectors, and it can
>> simplify some driver's open io accounting code.
>>
>> Gu Zheng (6):
>>    blk: introduce generic io stat accounting help function
>>    NVMe: use generic io stat accounting functions to simplify
>>      nvme_start/end_io_acct
>>    md/bcache: use generic io stats accounting functions to simplify io
>>      stat accounting
>>    drbd: use generic io stats accounting functions to simplify io stat
>>      accounting
>>    md: use generic io stats accounting functions to simplify io stat
>>      accounting
>>    block/rsxx: use generic io stats accounting functions to simplify io
>>      stat accounting
> 
> Thanks, this looks good. I'll apply it, except 2/6, since nvme no longer uses them.

OK.

Thanks,
Gu

> 


