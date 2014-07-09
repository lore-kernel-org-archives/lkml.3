Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaGIIwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:52:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33468 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbaGIIwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:52:46 -0400
Date: Wed, 9 Jul 2014 01:51:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v3 0/3] mm: introduce fincore() v3
Message-ID: <20140709085159.GA10693@infradead.org>
References: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140708121618.GA2554@infradead.org>
 <20140708132755.GA24698@nhori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708132755.GA24698@nhori>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 09:27:55AM -0400, Naoya Horiguchi wrote:
> On Tue, Jul 08, 2014 at 05:16:18AM -0700, Christoph Hellwig wrote:
> > Still a hard NAK for exposing page flags in a syscall ABI.  These are
> > way to volatile to go into an application interface.
> 
> Is there any specific reason that exporting via syscall ABI is more
> volatile than exporting via procfs as /proc/kpageflags alreadly does?

An optional proc debug output is very different from an actual system
call.

