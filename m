Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3ANNJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:09:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab3ANNJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:09:13 -0500
Date: Mon, 14 Jan 2013 13:09:11 +0000
From: Mel Gorman <mgorman@suse.de>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Unique commit-id for "mm: compaction: [P,p]artially revert
 capture of suitable high-order page"
Message-ID: <20130114130911.GQ13304@suse.de>
References: <CA+icZUW5kryOCpX96CkaS=5uX61FmiYE0mh7y6F0eT9Bh8eUGw@mail.gmail.com>
 <20130114103612.GO13304@suse.de>
 <CA+icZUUReY7LPjnF1xTjD-aJSYYqgo9tF9K8T8--r_HjRwgCHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+icZUUReY7LPjnF1xTjD-aJSYYqgo9tF9K8T8--r_HjRwgCHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 12:27:20PM +0100, Sedat Dilek wrote:
> On Mon, Jan 14, 2013 at 11:36 AM, Mel Gorman <mgorman@suse.de> wrote:
> > On Sun, Jan 13, 2013 at 05:12:45PM +0100, Sedat Dilek wrote:
> >> Hi Linus,
> >>
> >> I see two different commit-id for an identical patch (only subject
> >> line differs).
> >> [1] seems to be applied directly and [2] came with a merge of akpm-fixes.
> >> What is in case of backports for -stable kernels?
> >
> > I do not expect it to matter. I was going to use
> > 8fb74b9fb2b182d54beee592350d9ea1f325917a as the commit ID whenever I got
> > the complaint mail from Greg's tools about a 3.7 merge failure. The 3.7.2
> > backport looks like this.
> >
> 
> Oh cool and thanks!
> Are you planning to resend this backport-patch to the lists w/ a "3.7"
> (or for-3.7) in the commit-subject?
> 

Yes, when I get the reject mail from Greg's tools.

-- 
Mel Gorman
SUSE Labs
