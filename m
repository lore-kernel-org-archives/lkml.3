Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaBMWYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:24:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaBMWYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:24:08 -0500
Date: Thu, 13 Feb 2014 14:24:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10] mm: thrash detection-based file cache sizing v9
Message-Id: <20140213142407.f2c41f5c6561e708f2453e93@linux-foundation.org>
In-Reply-To: <20140213221126.GP6963@cmpxchg.org>
References: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org>
	<201402130321.s1D3LH41073563@www262.sakura.ne.jp>
	<20140213221126.GP6963@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014 17:11:26 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Hi Tetsuo,
> 
> On Thu, Feb 13, 2014 at 12:21:17PM +0900, Tetsuo Handa wrote:
> > Hello.
> > 
> > I got a lockdep warning shown below, and the bad commit seems to be de055616
> > \"mm: keep page cache radix tree nodes in check\" as of next-20140212
> > on linux-next.git.
> 
> Thanks for the report.  There is already a fix for this in -mm:
> http://marc.info/?l=linux-mm-commits&m=139180637114625&w=2
> 
> It was merged on the 7th, so it should show up in -next... any day
> now?

Tomorrow, if Stephen works weekends, which I expect he doesn't ;)

http://ozlabs.org/~akpm/mmotm/broken-out/mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
