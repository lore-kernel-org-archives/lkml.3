Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaBSSGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:06:36 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:43681 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaBSSGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:06:34 -0500
Date: Wed, 19 Feb 2014 13:06:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.torgue@st.com, linux-ide@vger.kernel.org,
        hdegoede@redhat.com
Subject: Re: [PATCH 3/3] ahci: st: Add support for ST's SATA IP
Message-ID: <20140219180630.GN10134@htj.dyndns.org>
References: <20140218233645.GP31892@mtj.dyndns.org>
 <20140219083025.GB10504@lee--X1>
 <20140219140458.GA10134@htj.dyndns.org>
 <20140219150121.GG10504@lee--X1>
 <20140219150654.GH10134@htj.dyndns.org>
 <20140219152336.GH10504@lee--X1>
 <20140219153624.GI10134@htj.dyndns.org>
 <20140219163937.GI10504@lee--X1>
 <20140219172602.GL10134@htj.dyndns.org>
 <20140219174041.GK10504@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219174041.GK10504@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 05:40:41PM +0000, Lee Jones wrote:
> Have you listened to a word I've said? Or have you managed to get your
> self all tangled up in what you _assumed_ was meant by the 3 words I
> mentioned about fairness at the very start of this conversation? Me
> thinks the latter might be true.

It wasn't only that.  Your mention of API compability later in the
thread or the notion of separate core and leaf developers were pretty
weird.  Things like

 "I was pertaining to the fact that requesting that a driver is
  converted to a non-existing API was wrong."

just don't make much sense.  That is a patchset which is pretty close
to completion and I'm asking people to converge on that.  That happens
regularly during development in the different layers.

I think what's fundamentally disturbing is this distinction between
what you're doing and what people working on the API are doing.  It's
not like the roles are bound by contracts and one party owes to the
other.  It seems that that's what leads you to think that asking your
driver updated for a pending patchset is unfair and the rest.

> Just because I don't contribute to your subsystem, it doesn't mean I
> don't contribute elsewhere.

Again, it's not about you being good and generously contributing.
It's about sharing of basic responsibility.  You say I'm not reading
what you're saying but what you're saying hasn't really changed since
the first post except for some weaseling.

> Here... let me help you down from that big horse! ;)

I'm surely doing some of that and thanks for helping me down but I do
hope you understand some of the points.

-- 
tejun
