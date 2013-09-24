Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3IXNUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:20:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3IXNUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:20:44 -0400
Date: Tue, 24 Sep 2013 09:20:14 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Kent Overstreet <kmo@daterainc.com>, axboe@kernel.dk,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/22] Immutable biovecs, block layer changes
Message-ID: <20130924132014.GA16165@redhat.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <20130808150954.GA30092@infradead.org>
 <20130808211529.GB15409@kmo-pixel>
 <20130924110012.GA7160@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924110012.GA7160@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24 2013 at  7:00am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> Just curious, what's the state of the remaining immutable bio work?

Hey Christoph,

Have you been over the patchset?  Looks sane to you?

Given how disruptive this patchset is to the block layer I'm wondering
how painful this change will be in combination with Jens' blk-mq
changes.  I'd prefer to see blk-mq before immutable biovecs; but I have
my own selfish reasons for that.

I'm also concerned about DM regressions given that a lot of DM code to
handle splitting a bio that spans target boundaries is ripped out, see:
https://patchwork.kernel.org/patch/2840657/

But that is just handwaving/FUD at this point cause I haven't put the
time to looking at this patchset close enough to feel comfortable.  I
can make reviewing this patchset a priority this week though.

Kent, have you rebased this patchset at all?  Do you have a git tree I
can clone to save the pain of pulling these patches out my my mbox,
etc.

Mike
