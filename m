Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935124Ab3BNXeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:34:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56037 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935089Ab3BNXeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:34:16 -0500
Date: Thu, 14 Feb 2013 23:34:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: ksignal changes for 3.9
Message-ID: <20130214233415.GW4503@ZenIV.linux.org.uk>
References: <511B346E.2090900@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511B346E.2090900@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 12:06:30PM +0530, Vineet Gupta wrote:
> Hi Al,
> 
> linux-next contains ksignal conversion for some of the architectures. Are you
> planning to complete that in 3.9 merge window. The reason I ask is so that the
> newer architectures (arc/metag - for a likely 3.9 merge) can queue the
> corresponding changes via respective trees.

That's hardly urgent; as far as I'm concerned, ksignal conversion is for 
3.10-rc1.  OTOH, these helpers are for 3.9-rc1, so any architecture that
cares to switch is welcome to it; less work for me that way.  Hell, as
far as I'm concerned, any maintainer of an in-tree architecture who's happy
with arch-$ARCHITECTURE is welcome to say so and pull it into their tree
right now.  That'll bring the stem of signal.git in, complete with ksignal
helpers to play with.  That part is in no-rebase mode.  The same goes for
arc and metag, except that you'd need to pull the branchpoint of arch-*
(signal.git#Base) instead...
