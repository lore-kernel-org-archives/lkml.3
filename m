Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaIVVx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:53:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbaIVVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:53:27 -0400
Date: Mon, 22 Sep 2014 14:53:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] kvm: Faults which trigger IO release the mmap_sem
Message-Id: <20140922145325.a63c848db6ebc02b5a4e5b35@linux-foundation.org>
In-Reply-To: <54209574.6020002@redhat.com>
References: <1410811885-17267-1-git-send-email-andreslc@google.com>
	<1410976308-7683-1-git-send-email-andreslc@google.com>
	<20140918002917.GA3921@kernel>
	<20140918061326.GC30733@minantech.com>
	<20140919003207.GA4296@kernel>
	<CAJu=L5_SPcqca0sBYcCLjt4hv6RQwa+QV8Fhi6t3mxz0+X=KSA@mail.gmail.com>
	<541BC848.6080001@redhat.com>
	<CAJu=L5-B+2POA1h0P5cO2-SBDpQpHi35bvcAxWw4G+GMaQeHCw@mail.gmail.com>
	<54209574.6020002@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 23:32:36 +0200 Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 22/09/2014 22:49, Andres Lagar-Cavilla ha scritto:
> >>> > > Paolo, should I recut including the recent Reviewed-by's?
> >> >
> >> > No, I'll add them myself.
> > Paolo, is this patch waiting for something? Is Gleb's Reviewed-by enough?
> 
> It's waiting for an Acked-by on the mm/ changes.
> 

The MM changes look good to me.
