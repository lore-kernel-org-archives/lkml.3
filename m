Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaDWRmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:42:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbaDWRmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:42:00 -0400
Date: Wed, 23 Apr 2014 13:41:31 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org,
        nacc@linux.vnet.ibm.com
Subject: Re: mmotm 2014-04-22-15-20 uploaded (uml 32- and 64-bit defconfigs)
Message-ID: <20140423134131.778f0d0a@redhat.com>
In-Reply-To: <5357F405.20205@infradead.org>
References: <20140422222121.2FAB45A431E@corp2gmr1-2.hot.corp.google.com>
	<5357F405.20205@infradead.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 10:10:29 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 04/22/14 15:21, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2014-04-22-15-20 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> > 
> > You will need quilt to apply these patches to the latest Linus release (3.x
> > or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> > http://ozlabs.org/~akpm/mmotm/series
> > 
> 
> include/linux/hugetlb.h:468:9: error: 'HPAGE_SHIFT' undeclared (first use in this function)

The patch adding HPAGE_SHIFT usage to hugetlb.h in current mmotm is this:

http://www.ozlabs.org/~akpm/mmotm/broken-out/hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported.patch

But I can't reproduce the issue to be sure what the problem is. Are you
building the kernel on 32bits? Can you provide the output of
"grep -i huge .config" or send your .config in private?
