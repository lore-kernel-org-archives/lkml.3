Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbaIQUCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:02:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139AbaIQUCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:02:17 -0400
Message-ID: <5419E89B.7020002@redhat.com>
Date: Wed, 17 Sep 2014 22:01:31 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@google.com>
CC: Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kvm: Faults which trigger IO release the mmap_sem
References: <1410811885-17267-1-git-send-email-andreslc@google.com>	<54184078.4070505@redhat.com>	<CAJu=L5_w+u6komiZB6RE1+9H5MiL+8RJBy_GYO6CmjqkhaG5Zg@mail.gmail.com>	<54188179.7010705@redhat.com>	<CAJu=L58z-=_KkZXpEiPjDUup8GpH7079HH39csmvgUxGkvXy0A@mail.gmail.com>	<54193BB2.8010500@redhat.com> <CAJu=L5-_1ZDyhnMTFePRCyECr1rVLeMqR6dCDK1m6baR7J7gpw@mail.gmail.com>
In-Reply-To: <CAJu=L5-_1ZDyhnMTFePRCyECr1rVLeMqR6dCDK1m6baR7J7gpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/09/2014 18:58, Andres Lagar-Cavilla ha scritto:
> Understood. So in patch 1, would kvm_gup_retry be ... just a wrapper
> around gup? That looks thin to me, and the naming of the function will
> not be accurate.

Depends on how you interpret "retry" ("with retry" vs. "retry after
_fast"). :)

My point was more to make possible future bisection easier, but I'm not
going to insist.  I'll queue the patch as soon as I get the required
Acked-by.

Paolo
