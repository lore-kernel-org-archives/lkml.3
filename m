Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab3HMSNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:13:00 -0400
Received: from one.firstfloor.org ([193.170.194.197]:39965 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3HMSM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:12:59 -0400
Date: Tue, 13 Aug 2013 20:12:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
Message-ID: <20130813181257.GV19750@two.firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
 <520A7651.8020301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A7651.8020301@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 11:09:21AM -0700, H. Peter Anvin wrote:
> On 08/09/2013 04:04 PM, Andi Kleen wrote:
> > The x86 user access functions (*_user) were originally very well tuned,
> > with partial inline code and other optimizations.
> > 
> > Then over time various new checks -- particularly the sleep checks for
> > a voluntary preempt kernel -- destroyed a lot of the tunings
> > 
> 
> Hi Andi,
> 
> Are you going to respin this patchset to address the feedback?

Yes. I'm dropping all the user checks.

But you could already merge the first patch, it's independent
of all the others and not affected by the feedback.

-Andi
