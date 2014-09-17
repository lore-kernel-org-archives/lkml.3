Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaIQN4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:56:14 -0400
Received: from kanga.kvack.org ([205.233.56.17]:45391 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbaIQN4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:56:13 -0400
Date: Wed, 17 Sep 2014 09:56:11 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Milosz Tanski <milosz@adfin.com>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/7] check for O_NONBLOCK in all read_iter instances
Message-ID: <20140917135611.GT24821@kvack.org>
References: <cover.1410810247.git.milosz@adfin.com> <c31364dee619b2c813c84437561569441fd5fd61.1410810247.git.milosz@adfin.com> <x49wq93xt5e.fsf@segfault.boston.devel.redhat.com> <CANP1eJF3Kxj+yOndLLS749bEy6=MmSJ1iBpPn6JPbKN3h3q87g@mail.gmail.com> <20140916214254.GK4322@dastard> <20140917122448.GR24821@kvack.org> <20140917134702.GB10720@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917134702.GB10720@thunk.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 09:47:02AM -0400, Theodore Ts'o wrote:
...
> % git version
> git version 2.1.0
> 
> Perhaps you and other people are using your own scripts, and not using
> git send-email?

That would be because none of my systems have git 2.1.0 on them.  Fedora 
(and EPEL) appear to still be back on git 1.9.3 which does not have git 
send-email.  Until that command is more widely propagated, I expect we'll 
see people making this mistake every once in a while.

		-ben
-- 
"Thought is the essence of where you are now."
