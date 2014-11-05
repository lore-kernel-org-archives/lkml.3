Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbaKEWNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:13:14 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45088 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbaKEWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:13:12 -0500
Message-Id: <1415225591.3444747.187568145.134CEE91@webmail.messagingengine.com>
X-Sasl-Enc: OsWyiODkv3Ay+zCqBlODb/Q5n2pRUuHn40ArTlHovsyG 1415225591
From: Martin Tournoij <martin@arp242.net>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-c51dec4f
In-Reply-To: <20141105201404.GH27083@thunk.org>
References: <1415200663.3247743.187387481.75CE9317@webmail.messagingengine.com>
 <545A7B00.1040309@gmail.com> <20141105201404.GH27083@thunk.org>
Subject: Re: [RFC] The SIGINFO signal from BSD
Date: Wed, 05 Nov 2014 23:13:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014, at 20:31, Austin S Hemmelgarn wrote:
> The people to talk to about that for the core 
> utilities on Linux would be the maintainers of the GNU coreutils, or 
> whatever your distribution might use in their place (I think it's very 
> unlikely that busybox or toybox would implement it however).

Well, if the kernel doesn't provide the feature, then we can be sure it
will never be implemented :-)
I thought this was a good place to start asking,, and even if GNU
coreutils opt to not implement this for whatever reasons, other
applications still can (mine will!)
Besides, there are already many tools which use this feature when
available, these would for with no or minimal adjustments.


On Wed, Nov 5, 2014, at 21:14, Theodore Ts'o wrote: 
> In a world where we have a GUI desktop, I suspect implementing ^T is
> much less interesting but if someone were to submit a patch to at
> least make ^T send a SIGINFO, I can't think of a reason why it
> wouldn't be accepted.  (BTW, if you're going to do this, note that ^T
> could be remapped to any control character via stty; so to do this we
> would need to define an extra index in c_cc[] array in the struct
> termios.)

Thanks, this is what I needed :-) I wondered if there is a specific reason
it's not implemented, or if it was just something no one ever did.

I can start my investigation in the kernel sources ;)

Thanks,
Martin
