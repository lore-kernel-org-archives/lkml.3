Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbaCRXKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:10:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbaCRXKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:10:52 -0400
Date: Tue, 18 Mar 2014 16:10:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUG -next] "mm: per-thread vma caching fix 5" breaks s390
Message-Id: <20140318161050.ab184d30edf4b2446a2060de@linux-foundation.org>
In-Reply-To: <CA+8MBbKaaYXNV_XZNRp=wn-+3Mqd4+JVoXn_d+eo=PQR17i1SQ@mail.gmail.com>
References: <20140318124107.GA24890@osiris>
	<CA+8MBbKaaYXNV_XZNRp=wn-+3Mqd4+JVoXn_d+eo=PQR17i1SQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 16:06:59 -0700 Tony Luck <tony.luck@gmail.com> wrote:

> On Tue, Mar 18, 2014 at 5:41 AM, Heiko Carstens
> <heiko.carstens@de.ibm.com> wrote:
> > Given that this is just an addon patch to Davidlohr's "mm: per-thread
> > vma caching" patch I was wondering if something in there is architecture
> > specific.
> > But it doesn't look like that. So I'm wondering if this only breaks on
> > s390?
> 
> I'm seeing this same BUG_ON() on ia64 (when trying out next-20140318)

-next is missing
http://ozlabs.org/~akpm/mmots/broken-out/mm-per-thread-vma-caching-fix-6.patch.
Am presently trying to cook up an mmotm for tomorrow's -next.  
