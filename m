Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3JCWuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:50:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab3JCWuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:50:21 -0400
Date: Thu, 3 Oct 2013 18:50:09 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 16/22] dm: Refactor for new bio cloning/splitting
Message-ID: <20131003225009.GA24173@redhat.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-17-git-send-email-kmo@daterainc.com>
 <20130928045909.GA19745@redhat.com>
 <20131003031738.GA27418@kmo-pixel>
 <20131003032320.GA15322@redhat.com>
 <20131003214525.GA12183@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003214525.GA12183@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03 2013 at  5:45pm -0400,
Kent Overstreet <kmo@daterainc.com> wrote:

> On Wed, Oct 02, 2013 at 11:23:21PM -0400, Mike Snitzer wrote:
> > Great, thanks for finding this, I'll test and review the code further.
> 
> Cool - let me know if you find anything else (how thoroughly do you
> think you've tested it so far?)

Not very, the issue you resolved was a blocker for DM.  But I haven't
even verified your fix yet though... will do tomorrow with more
extensive testing using the dm-thinp and dm-cache test-suite.
