Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaBSRAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:00:44 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:45300 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaBSRAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:00:41 -0500
Date: Wed, 19 Feb 2014 12:00:37 -0500
From: Tejun Heo <tj@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.torgue@st.com, linux-ide@vger.kernel.org,
        hdegoede@redhat.com
Subject: Re: [PATCH 3/3] ahci: st: Add support for ST's SATA IP
Message-ID: <20140219170037.GK10134@htj.dyndns.org>
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

On Wed, Feb 19, 2014 at 04:39:37PM +0000, Lee Jones wrote:
> Again, that's not what I said. It's great that your subsystem is being
> improved, but insisting that anyone who submits new code to rebase
> on top of some development patches which only exist in mail form, and
> refusing to take patches until they do so doesn't seem right to me.

No policy is perfect and nothing can be decided solely on single
policy.  There of course are trade-offs to make depending on the
specific circumstances.  The problem, here, is that what has been
going on is skewed towards one extreme and has potential to develop
into a fairly large mess if left uncorrected.

The message I've been sending out has been pretty clear.  There are
multiple people duplicating about the same thing in their drivers.
Fortunately, Hans' refactoring is pretty close to completion and
should help simplifying most of them.  I'm not even asking you to do
the bulk of work.  Just take a look at it and help / push if you can.
It may be unfortunate that the circumstances haven't been completely
aligned for your convenience but that's what needs to be done to keep
things sustainable.

This is a collaborative work and what I asked you isn't some
insurmountable amount of extra work.  It's just beyond me that your
response is "it's not fair".  No wonder the whole thing has been
drifting towards mess.  That's not how this works.  Judging from your
linaro address, I assume you have been involved with some upstream
work, how can this possibly be your response?  Such attitude is
actively harmful and has no place in upstream development.

Again, of course, there can be trade-offs.  We sometimes do need to
take termporal hits in maintainability for faster hardware enablement
or whatnot; however, we can't do that without trust that the people
dumping stuff which needs later cleanups would actually help.
Unfortnately, I have close to zero trust given the recent developments
and your "it's not fair, that's not my responsibility" attitude
clearly confirms the conclusion.

So, please take long look at how you perceive upstream development.
It's a collaborative process.  Other people don't owe you by default.

-- 
tejun
