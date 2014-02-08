Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaBHQql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:46:41 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45667 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBHQqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:46:40 -0500
Date: Sat, 8 Feb 2014 17:46:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 10/11] smp: Remove wait argument from
 __smp_call_function_single()
Message-ID: <20140208164633.GA21882@localhost.localdomain>
References: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
 <1391876320-25068-11-git-send-email-fweisbec@gmail.com>
 <20140208164247.GA11028@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140208164247.GA11028@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 08:42:47AM -0800, Christoph Hellwig wrote:
> Might be worth to give the function a saner name than just the __-prefix
> if you touch all callers anyway.
> 


Good point. How about smp_call_function_single_async() ?
