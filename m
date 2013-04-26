Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab3DZCBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 22:01:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab3DZCBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 22:01:36 -0400
Date: Thu, 25 Apr 2013 22:01:01 -0400
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
Message-ID: <20130426020101.GA21162@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Minchan Kim <minchan@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
	linux-mm <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51559150.3040407@oracle.com>
 <20130410080202.GB21292@blaptop>
 <5166CEDD.9050301@oracle.com>
 <20130411151323.89D40E0085@blue.fi.intel.com>
 <5166D355.2060103@oracle.com>
 <20130424154607.60e9b9895539eb5668d2f505@linux-foundation.org>
 <5179CF8F.7000702@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5179CF8F.7000702@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 08:51:27PM -0400, Sasha Levin wrote:
 > On 04/24/2013 06:46 PM, Andrew Morton wrote:
 > > Guys, did this get fixed?
 > 
 > I've stopped seeing that during fuzzing, so I guess that it got fixed somehow...

We've had reports of users hitting this in 3.8

eg:
https://bugzilla.redhat.com/show_bug.cgi?id=947985
https://bugzilla.redhat.com/show_bug.cgi?id=956730 

I'm sure there are other reports of it too.

Would be good if we can figure out what fixed it (if it is actually fixed)
for backporting to stable

	Dave
 
