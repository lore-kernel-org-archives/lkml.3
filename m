Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaBSR0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:26:12 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:50118 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaBSR0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:26:08 -0500
Date: Wed, 19 Feb 2014 12:26:02 -0500
From: Tejun Heo <tj@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.torgue@st.com, linux-ide@vger.kernel.org,
        hdegoede@redhat.com
Subject: Re: [PATCH 3/3] ahci: st: Add support for ST's SATA IP
Message-ID: <20140219172602.GL10134@htj.dyndns.org>
References: <1392641818-23419-1-git-send-email-lee.jones@linaro.org>
 <1392641818-23419-3-git-send-email-lee.jones@linaro.org>
 <20140218233645.GP31892@mtj.dyndns.org>
 <20140219083025.GB10504@lee--X1>
 <20140219140458.GA10134@htj.dyndns.org>
 <20140219150121.GG10504@lee--X1>
 <20140219150654.GH10134@htj.dyndns.org>
 <20140219152336.GH10504@lee--X1>
 <20140219153624.GI10134@htj.dyndns.org>
 <20140219163937.GI10504@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219163937.GI10504@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more things just in case.

On Wed, Feb 19, 2014 at 04:39:37PM +0000, Lee Jones wrote:
> It tells me that Hans has more spare time than I do.

This is the crux of the problem, isn't it?  The party who is creating
load should also partake in and invest resource into making the
infrastructure for it.  What I can't understand is how one can claim
"unfairness" at having to contribute to such effort when that is
clearly the party which is the primary beneficiary of the added load.
If you have *any* mature sense of fairness, not this childish "it's
not going my way", the irony should be clear to you.

> This work would even be something I'd be interested in helping out
> with - even in my own time, but the way you speak to people doesn't
> exactly inspire them to go out of my way to work with you does it?

Given the circumstances, I don't think depending on good wills of the
involved parties is a viable strategy and wanted to make it clear that
the responsibility of chipping in for long term maintainability is on
everyone who wants to make use of the code base.  This is beyond good
will.  It's the fundamental sharing of responsibility for
sustainability.  I'd love to have good will but I can't build that on
top of a notion as rotten as "it's not fair, it's not my
responsibility".

> Again, that's not what I said. It's great that your subsystem is being
> improved, but insisting that anyone who submits new code to rebase
> on top of some development patches which only exist in mail form, and
> refusing to take patches until they do so doesn't seem right to me.

If I apply your patch now, Hans has one more driver to worry about in
doing the work that he himself isn't directly benefiting from but
everybody needs.  In what world is that fair?

So, sorry about going f bomb on you, but you shouldn't be thinking
what you're thinking.  There's some serious misguidance going on
there.

-- 
tejun
