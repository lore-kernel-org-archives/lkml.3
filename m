Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3HFGTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 02:19:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36349 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab3HFGTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 02:19:51 -0400
Date: Mon, 5 Aug 2013 23:19:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130806061932.GA20485@infradead.org>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
 <20130805081641.GA24808@gmail.com>
 <20130805082320.GA9562@infradead.org>
 <20130805083132.GE26746@gmail.com>
 <20130805083434.GA20606@infradead.org>
 <20130805090857.GA26940@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805090857.GA26940@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 11:08:57AM +0200, Ingo Molnar wrote:
> You never replied to the original counter-arguments, such as this one from 
> Linus:
> 
>   http://article.gmane.org/gmane.linux.kernel/849965

The only thing Linus sais is that it's trivial to generate a subpackage,
and that opofile is a desaster.  Both of them are 100% correct but at
the same time entirely miss the point.

Yes, oprofile was and is a desaster, but that has aboslutely nothing to
do with where the code lives.

And yes, it's easy to generate a subpackage, but you still need all the
source tree first.  There's a reason why things like X.org got split up
(too fine grained in my opinion, but that's another story).

As said I very much disagree with having the userspace perf tree in the
kernel still, but I've also given up on the fight as I have more
important things to do.

And as said before it has nothing to do with the issue discussed here
right now.
