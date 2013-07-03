Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab3GCORt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425Ab3GCORs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:17:48 -0400
Date: Wed, 3 Jul 2013 10:16:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Message-ID: <20130703141635.GC1460@redhat.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com>
 <20130702154214.GC22603@redhat.com>
 <20130703155933.3f3de4b9@holzheu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703155933.3f3de4b9@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 03:59:33PM +0200, Michael Holzheu wrote:
> On Tue, 2 Jul 2013 11:42:14 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Mon, Jul 01, 2013 at 09:32:37PM +0200, Michael Holzheu wrote:
> 
> [snip]
> 
> > > This handler works as follows:
> > > 
> > > * Get already available or new page from page cache (find_or_create_page)
> > > * Check if /proc/vmcore page is filled with data (PageUptodate)
> > > * If yes:
> > >   Return that page
> > > * If no:
> > >   Fill page using __vmcore_read(), set PageUptodate, and return page
> > > 
> > > Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > In general vmcore related changes look fine to me. I am not very familiar
> > with the logic of finding pages in page cache and using page uptodate
> > flag.
> > 
> > Hatayama, can you please review it.
> > 
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Hello Vivek,
> 
> If Hatayama accepts the patch, should we then send the patch series to
> Andrew Morton?

Yes, once hatayama reviews the patch, please send it to Anderew Morton for
for inclusion of paches.

Thanks
Vivek
