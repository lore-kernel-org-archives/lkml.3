Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaI2V1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:27:03 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55622 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaI2V1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:27:00 -0400
Date: Mon, 29 Sep 2014 21:26:55 +0000
From: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org, mroos@linux.ee
Subject: Re: [PATCH v2] 3c59x: fix bad split of cpu_to_le32(pci_map_single())
Message-ID: <20140929212655.GE15737@erable>
References: <20140925151519.GA12225@erable>
 <20140929.153748.2020820992295588670.davem@davemloft.net>
 <20140929194512.GB15737@erable>
 <20140929.160813.1739128124571074828.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929.160813.1739128124571074828.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When: 2014-09-29_1@16-08-13 -0400
Who:  David Miller
What:
> From: Sylvain 'ythier' Hitier <sylvain.hitier@gmail.com>
> Date: Mon, 29 Sep 2014 19:45:12 +0000
> 
> You should not submit patches as a reply to a discussion, it must be
> done as a fresh mailing list posting.

Ah, didn't know.
I've seen this be done before, such as:
    http://thread.gmane.org/gmane.linux.kernel/1759680/focus=1775068
and hence did the same.

And searching case-insensitively "reply", "fresh", "new", "thread" in
Documentation/SubmittingPatches shed no light on this topic.

> The posting must also be properly formed, in that "Subject: " should
> be of the form "[PATCH vx] ${subsystem}: Description."  and the mail
> message body must be the commit message with appropriate signoffs
> and ACKs, then the patch comes next.
> 
> This is fully described, in detail, in Documentation/SubmittingPatches

Ah, OK, you meant:
    Please use git format-patch so that I could use git am.

Did that.

(Thanks, you made me learn about git format-patch by myself.
That is, only describing the format makes you a
teacher-who-let-the-padawan-find-the-right-tool-by-self-work instead of a
teacher-who-gives-the-solution.)

> > Would it be OK for me re-sending my part as v3 including Neil's ack?
> > Or are you expecting a unique patch combining Neil's changes and mine?

I went for a v3.


Regards,
Sylvain "ythier" Hitier

-- 
Business is about being busy, not being rich...
Lived 777 days in a Debian package => http://en.wikipedia.org/wiki/Apt,_Vaucluse
There's THE room for ideals in this mechanical place!
