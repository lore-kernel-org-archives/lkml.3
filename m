Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaLWMSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:18:21 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44287 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbaLWMSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:18:20 -0500
Date: Tue, 23 Dec 2014 13:18:15 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [RFC PATCH 07/17] block: replace sg_iovec with iov_iter
Message-ID: <20141223121815.GE15080@gmail.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
 <20141223104401.GB27600@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141223104401.GB27600@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.12.2014 02:44, Christoph Hellwig wrote:
> Does this and the next three patches really depend on the earlier ones?
> Unless I'm missing something they are cleanups on their own.
> 
> It might make sense to get all these cleanups out as a preparatory
> series first.

I think so too. Patches #07-10 can be split into a separate patchset.
I guess they are included just because Kent tried to follow up
suggestions in the previous discussion.
I don't care about either way. So I'll split them up.

Thanks,
Dongsu
