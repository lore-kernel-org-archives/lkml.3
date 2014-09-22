Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaIVVcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:32:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaIVVcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:32:50 -0400
Message-ID: <54209574.6020002@redhat.com>
Date: Mon, 22 Sep 2014 23:32:36 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@google.com>
CC: Wanpeng Li <wanpeng.li@linux.intel.com>, Gleb Natapov <gleb@kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] kvm: Faults which trigger IO release the mmap_sem
References: <1410811885-17267-1-git-send-email-andreslc@google.com>	<1410976308-7683-1-git-send-email-andreslc@google.com>	<20140918002917.GA3921@kernel>	<20140918061326.GC30733@minantech.com>	<20140919003207.GA4296@kernel>	<CAJu=L5_SPcqca0sBYcCLjt4hv6RQwa+QV8Fhi6t3mxz0+X=KSA@mail.gmail.com>	<541BC848.6080001@redhat.com> <CAJu=L5-B+2POA1h0P5cO2-SBDpQpHi35bvcAxWw4G+GMaQeHCw@mail.gmail.com>
In-Reply-To: <CAJu=L5-B+2POA1h0P5cO2-SBDpQpHi35bvcAxWw4G+GMaQeHCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2014 22:49, Andres Lagar-Cavilla ha scritto:
>>> > > Paolo, should I recut including the recent Reviewed-by's?
>> >
>> > No, I'll add them myself.
> Paolo, is this patch waiting for something? Is Gleb's Reviewed-by enough?

It's waiting for an Acked-by on the mm/ changes.

Paolo
