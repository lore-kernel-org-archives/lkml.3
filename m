Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaFYS4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:56:37 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:46632 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaFYS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:56:36 -0400
MIME-Version: 1.0
X-Originating-IP: [80.196.35.44]
In-Reply-To: <20140625113715.GA4525@infradead.org>
References: <1403651531-24891-1-git-send-email-m@bjorling.me>
	<1403651531-24891-2-git-send-email-m@bjorling.me>
	<20140625113715.GA4525@infradead.org>
Date: Wed, 25 Jun 2014 20:56:35 +0200
Message-ID: <CAOu_J6nTcEjEpAe+S7Wg9SxUj_u=QitsDjYkKmCpaGP1MAexhw@mail.gmail.com>
Subject: Re: [PATCH v9] NVMe: Convert to blk-mq
From: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Jens Axboe <axboe@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Rob Nelson <rlnelson@google.com>, Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 1:37 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 25, 2014 at 01:12:11AM +0200, Matias Bj??rling wrote:
>> This converts the current NVMe driver to utilize the blk-mq layer.
>>
>> Contributions in this patch from:
>>
>>   Sam Bradshaw <sbradshaw@micron.com>
>>   Jens Axboe <axboe@kernel.dk>
>>   Keith Busch <keith.busch@intel.com>
>>   Christoph Hellwig <hch@infradead.org>
>>   Robert Nelson <rlnelson@google.com>
>
> Is there really something from me in here except for a bit of review?
>

Only the review. Do you want me to change it to a Reviewed-by?
