Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbaAHVcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:32:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43620 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076AbaAHVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:32:08 -0500
Message-ID: <52CDC3A3.5050203@kernel.dk>
Date: Wed, 08 Jan 2014 14:31:15 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: use __smp_call_function_single directly
References: <20140108173337.GA29514@infradead.org>
In-Reply-To: <20140108173337.GA29514@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 10:33 AM, Christoph Hellwig wrote:
> __smp_call_function_single already avoids multiple IPIs by internally
> queing up the items, and now also is available for non-SMP builds as
> a trivially correct stub, so there is no need to wrap it.  If the
> additional lock roundtrip cause problems my patch to convert the
> generic IPI code to llists is waiting to get merged will fix it.

Thanks Christoph, applied it.

-- 
Jens Axboe

