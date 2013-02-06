Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab3BFWdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:33:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab3BFWc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:32:57 -0500
Date: Wed, 6 Feb 2013 14:32:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 21/77] block: fix synchronization and limit check in
 blk_alloc_devt()
Message-Id: <20130206143256.21a55902.akpm@linux-foundation.org>
In-Reply-To: <20130206222755.GD2875@htj.dyndns.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
	<1360179649-22465-22-git-send-email-tj@kernel.org>
	<20130206142422.b2f8eac6.akpm@linux-foundation.org>
	<20130206222755.GD2875@htj.dyndns.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013 14:27:55 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Wed, Feb 06, 2013 at 02:24:22PM -0800, Andrew Morton wrote:
> > This gets all tangled up with
> > http://ozlabs.org/~akpm/mmotm/broken-out/block-fix-ext_devt_idr-handling.patch,
> > which appears to solve the same issue.
> > 
> > What to do?
> 
> Can you please drop 21 and 22?  Everything else shouldn't be affected
> and we can sort these out later.  The actual deprecation patch is held
> off for now anyway.

hm, I could.  Instead I merged your patch on top of Tomas's and marked
Tomas's patch for -stable as well.  Sound OK?

