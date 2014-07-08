Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaGHNix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:38:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbaGHNiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:38:50 -0400
Date: Tue, 8 Jul 2014 09:27:55 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20140708132755.GA24698@nhori>
References: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140708121618.GA2554@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708121618.GA2554@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:16:18AM -0700, Christoph Hellwig wrote:
> Still a hard NAK for exposing page flags in a syscall ABI.  These are
> way to volatile to go into an application interface.

Is there any specific reason that exporting via syscall ABI is more
volatile than exporting via procfs as /proc/kpageflags alreadly does?

Thanks,
Naoya Horiguchi
