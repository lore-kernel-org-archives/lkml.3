Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbbAHRn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:43:59 -0500
Received: from fn.samba.org ([216.83.154.106]:50775 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116AbbAHRn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:43:56 -0500
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 12:43:56 EST
Date: Thu, 8 Jan 2015 09:36:10 -0800
From: Jeremy Allison <jra@samba.org>
To: Milosz Tanski <milosz@adfin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v12 00/20] DAX: Page cache bypass for filesystems on
 memory storage
Message-ID: <20150108173610.GB6189@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
 <20141210140347.GA23252@infradead.org>
 <20141210141211.GD2220@wil.cx>
 <20150105184143.GA665@infradead.org>
 <20150106004714.6d63023c.akpm@linux-foundation.org>
 <CANP1eJHOMSP8GYc_1pi8ciZZFWR0dH=N5a4HA=RYezohDmm+Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANP1eJHOMSP8GYc_1pi8ciZZFWR0dH=N5a4HA=RYezohDmm+Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 11:28:40AM -0500, Milosz Tanski wrote:
> >
> 
> Andrew I  got busier with my other job related things between the
> Thanksgiving & Christmas then anticipated. However, I have updated and
> taken apart the patchset into two pieces (preadv2 and pwritev2). That
> should make evaluating the two separately easier. With the help of
> Volker I hacked up preadv2 support into samba and I hopefully have
> some numbers from it soon. Finally, I'm putting together a test case

I'd be very interested in seeing that patch code and those
numbers !

Cheers,

	Jeremy.
