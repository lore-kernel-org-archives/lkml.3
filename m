Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3J3AHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:07:16 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37336 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3J3AHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:07:14 -0400
Date: Tue, 29 Oct 2013 17:06:54 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org
Subject: Re: [PATCH] Immutable biovecs
Message-ID: <20131030000654.GA27129@kmo>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
 <20131029203647.GH22549@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029203647.GH22549@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 02:36:47PM -0600, Jens Axboe wrote:
> On Tue, Oct 29 2013, Kent Overstreet wrote:
> > Jens - this patch series is ready to go, driver maintainers have reviewed and
> > tested it and the code's been essentially done for probably a year now - can we
> > get this into 3.13?
> 
> We can - your series doesn't apply to for-3.13/core however, can you
> check?

Rebased onto your for-3.13/core branch, did a make allmodconfig and ran my
bcache tests (there was one trivial fix needed for blk-mq, the rest rebased
cleanly) - it's ready for you to pull from in my usual location:

git://evilpiepirate.org/~kent/linux-bcache.git for-jens
