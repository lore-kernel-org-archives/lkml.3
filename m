Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab3ANS4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:56:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50397 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200Ab3ANS4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:56:14 -0500
Message-ID: <50F454C2.6000509@kernel.dk>
Date: Mon, 14 Jan 2013 19:56:02 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: linux-next <linux-next@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [next-20130114] Call-trace in LTP (lite) madvise02 test (block|mm|vfs
 related?)
References: <CA+icZUW1+BzWCfGkbBiekKO8b6KiyAiyXWAHFmVUey2dHnSTzw@mail.gmail.com>
In-Reply-To: <CA+icZUW1+BzWCfGkbBiekKO8b6KiyAiyXWAHFmVUey2dHnSTzw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-14 19:33, Sedat Dilek wrote:
> Hi,
> 
> while running LTP lite on my next-20130114 kernel I hit this
> call-trace (file attached).
> 
> Looks to me like problem in the block layer, but not sure.
> Might one of the experts have look at it?

Really? 600kb of data to look through? Can't you just paste the actual
error, I can't even find it...

-- 
Jens Axboe

