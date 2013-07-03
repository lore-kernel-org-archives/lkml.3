Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3GCN7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:59:45 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:51737 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3GCN7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:59:43 -0400
Date: Wed, 3 Jul 2013 15:59:33 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Message-ID: <20130703155933.3f3de4b9@holzheu>
In-Reply-To: <20130702154214.GC22603@redhat.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130702154214.GC22603@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070313-6892-0000-0000-00000596C2D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013 11:42:14 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Jul 01, 2013 at 09:32:37PM +0200, Michael Holzheu wrote:

[snip]

> > This handler works as follows:
> > 
> > * Get already available or new page from page cache (find_or_create_page)
> > * Check if /proc/vmcore page is filled with data (PageUptodate)
> > * If yes:
> >   Return that page
> > * If no:
> >   Fill page using __vmcore_read(), set PageUptodate, and return page
> > 
> > Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> In general vmcore related changes look fine to me. I am not very familiar
> with the logic of finding pages in page cache and using page uptodate
> flag.
> 
> Hatayama, can you please review it.
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

Hello Vivek,

If Hatayama accepts the patch, should we then send the patch series to
Andrew Morton?

Michael

