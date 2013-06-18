Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab3FRTIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:08:19 -0400
Received: from kanga.kvack.org ([205.233.56.17]:46238 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab3FRTIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:08:18 -0400
Date: Tue, 18 Jun 2013 15:08:17 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Zach Brown <zab@redhat.com>, Kent Overstreet <koverstreet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v3 next/akpm] aio: convert the ioctx list to radix tree
Message-ID: <20130618190817.GC16399@kvack.org>
References: <1366026055-28604-1-git-send-email-octavian.purdila@intel.com> <20130612181440.GC6151@google.com> <20130612182430.GE14404@kvack.org> <20130612194005.GC8389@lenny.home.zabbo.net> <CAE1zotJuQkxqJhV32nAMb-gq3gGzNaL882J4tGoMvj38TMDYMA@mail.gmail.com> <CAE1zotLsK47ni8-Dky6fyqZmeN3zGqKvcne9HDQbUwDi4Cia_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotLsK47ni8-Dky6fyqZmeN3zGqKvcne9HDQbUwDi4Cia_Q@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:05:22PM +0300, Octavian Purdila wrote:
> On Fri, Jun 14, 2013 at 5:20 PM, Octavian Purdila
> <octavian.purdila@intel.com> wrote:
> > I picked up Ben's patch and incorporated Zach's idea and the first
> > results look promising, as expected. I am going to do a full test with
> > the same workload I've used for rbtree and come back with the results
> > and the patch in a day or so.
> >
> 
> Unfortunately, I still see performance degradation for the one ioctx
> case even when using IDR. I am using the same fio benchmark as before.

How much of a regression?

		-ben
-- 
"Thought is the essence of where you are now."
