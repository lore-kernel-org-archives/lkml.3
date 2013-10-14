Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3JNN7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:59:35 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:52667 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3JNN7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:59:34 -0400
Date: Mon, 14 Oct 2013 09:59:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Hong zhi guo <honkiko@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, vgoyal@redhat.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Message-ID: <20131014135929.GH4722@htj.dyndns.org>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
 <20131014133620.GF4722@htj.dyndns.org>
 <CAA7+ByWPM2Pizm+dP1AxPM7Ut-w=AtRfD2GkCK-0OVh+C2Twkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA7+ByWPM2Pizm+dP1AxPM7Ut-w=AtRfD2GkCK-0OVh+C2Twkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 09:53:54PM +0800, Hong zhi guo wrote:
> I've not tested hierarchical setup yet. I'll do it tomorrow.
> BTW, what kind of setup do you expect? Is hierarchy of 2 levels enough?

That should cover most of the functionalities but going for 3 levels
can't hurt, right?

Thanks.

-- 
tejun
