Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaIVUtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:49:42 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:45802 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaIVUtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:49:40 -0400
MIME-Version: 1.0
In-Reply-To: <541BC848.6080001@redhat.com>
References: <1410811885-17267-1-git-send-email-andreslc@google.com>
	<1410976308-7683-1-git-send-email-andreslc@google.com>
	<20140918002917.GA3921@kernel>
	<20140918061326.GC30733@minantech.com>
	<20140919003207.GA4296@kernel>
	<CAJu=L5_SPcqca0sBYcCLjt4hv6RQwa+QV8Fhi6t3mxz0+X=KSA@mail.gmail.com>
	<541BC848.6080001@redhat.com>
Date: Mon, 22 Sep 2014 13:49:39 -0700
Message-ID: <CAJu=L5-B+2POA1h0P5cO2-SBDpQpHi35bvcAxWw4G+GMaQeHCw@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: Faults which trigger IO release the mmap_sem
From: Andres Lagar-Cavilla <andreslc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Gleb Natapov <gleb@kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:08 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Il 19/09/2014 05:58, Andres Lagar-Cavilla ha scritto:
> > Paolo, should I recut including the recent Reviewed-by's?
>
> No, I'll add them myself.

Paolo, is this patch waiting for something? Is Gleb's Reviewed-by enough?

Thanks much
Andres

>
>
> Paolo
