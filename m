Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3JKCjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 22:39:54 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55696 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3JKCjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 22:39:52 -0400
Date: Thu, 10 Oct 2013 19:38:11 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH] Fix for bcache regression
Message-ID: <20131011023811.GA19050@kmo>
References: <1381451475-24551-1-git-send-email-kmo@daterainc.com>
 <20131011022313.GA31029@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011022313.GA31029@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 08:23:13PM -0600, Jens Axboe wrote:
> On Thu, Oct 10 2013, Kent Overstreet wrote:
> > Linus, please apply - the last fix in the bugfix series I sent you had an
> > embarassing screwup...
> > 
> > For 3.13, shall I start sending you pull requests directly?
> 
> Sorry I dropped the ball on that one, it's the first time ever I've
> missed a deadline. It's being ramped up again, kernel time will be
> plenty again shortly.

No worries, I've been behind on plenty of stuff too and wouldn't have
much room to complain :)

Probably best that the giant pull ended up waiting a bit longer anyways
with the bugs I've still been fixing. Anyways, bcache is self contained
enough I doubt it really matters, so whatever the two of you prefer is
fine by me.
