Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3IFN5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:57:41 -0400
Received: from imap.thunk.org ([74.207.234.97]:55652 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab3IFN5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:57:39 -0400
Date: Fri, 6 Sep 2013 09:57:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random, Add user configurable get_bytes_random()
Message-ID: <20130906135731.GA1249@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
References: <1378383524-27983-1-git-send-email-prarit@redhat.com>
 <20130905144818.GA23661@thunk.org>
 <52289E6C.8090301@redhat.com>
 <20130905190334.GC23661@thunk.org>
 <20130905194907.GE23661@thunk.org>
 <5229C5D4.5070600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5229C5D4.5070600@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 08:08:52AM -0400, Prarit Bhargava wrote:
> 
> Your argument seems to surround the idea that putting stuff on the internet is
> safe.  It isn't.  If you've believed that then you've had your head in the sand
> and I've got a lot of land in Florida to sell you.

I have no idea how you are getting this idea.  My argument is that
putting all of our faith in one person (whether it is DNI Clapper
lying to the US Congress), or one company (like Intel, Qualcomm, TI,
etc.) is a bad idea.  Software can be audited.  Hardware can not.  We
can at least test whether or not a network card is performing
according to its specifications.  But a HWRNG is by definition
something that can't be tested.  Statistical tests are not sufficient
to prove that the HWRNG has not been gimmicked.

Hence, unless you can show me where the speed advantage of bypassing
the entropy pool is needed, why should we do this?  And if there is a
specific place where need to consider adjusting the security
vs. performance tradeoff, let's do that on a case by case basis,
instead of making a global change.

Hence, your patch is IMHO irresponsible.  It exposes us to more risk,
for an undefined theoretical benefit.

Of course nothing on the internet is going to be perfectly safe.  But
that doesn't mean that we shouldn't make it harder for any government
agency, whether it is the Chinese MSS, the US NSA, or the UK GHCQ,
from being able to easily perform casual, dragnet-style surveillence.

     	   	   	  	  	  		- Ted
