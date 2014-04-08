Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbaDHTGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:06:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128AbaDHTGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:06:31 -0400
Date: Tue, 8 Apr 2014 20:06:26 +0100
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for
 _PAGE_NUMA v2
Message-ID: <20140408190625.GQ7292@suse.de>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
 <53440A5D.6050301@zytor.com>
 <CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com>
 <20140408164652.GL7292@suse.de>
 <CA+55aFwrwYmWFXWpPeg-keKukW0=dwvmUBuN4NKA=JcseiUX3g@mail.gmail.com>
 <20140408185146.GP7292@suse.de>
 <CA+55aFwXuwE8=4h2LrjfjjMhE35pj4W6oOXYFuWkkB65eya=XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+55aFwXuwE8=4h2LrjfjjMhE35pj4W6oOXYFuWkkB65eya=XA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 11:55:22AM -0700, Linus Torvalds wrote:
> On Tue, Apr 8, 2014 at 11:51 AM, Mel Gorman <mgorman@suse.de> wrote:
> >
> > I picked a solution. The posted series uses a different bit.
> 
> Yes, and I actually like that. I have nothing against your patch
> series. I'm ranting and raving because you then seemed to say "maybe
> we shouldn't pick a solution after all" when you said:
> 
> > > If you are ok with leaving _PAGE_NUMA as _PAGE_PROTNONE
> 
> which was what I reacted to.
> 

Ok, my bad. To be absolutly clear I want to move away from aliasing the
_PAGE_PROTNONE bit. As David reports the series works for him, I'll wait
a bit to see if there are objections or an alternative patch series from
another direction. If not, I'll remove the RFC and repost it through the
x86 maintainers.

-- 
Mel Gorman
SUSE Labs
