Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaENTGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:06:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbaENTGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:06:50 -0400
Message-ID: <5373BE94.1060800@redhat.com>
Date: Wed, 14 May 2014 15:05:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, linux-arch@vger.kernel.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org
CC: Hirokazu Takata <takata@linux-m32r.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org
Subject: Re: [PATCH 12/27] m32r: Use generic tlb.h
References: <1400093999-18703-1-git-send-email-richard@nod.at> <1400093999-18703-13-git-send-email-richard@nod.at>
In-Reply-To: <1400093999-18703-13-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 02:59 PM, Richard Weinberger wrote:
> As everything we need is now in generic tlb.h
> we can drop our own one.
> 
> Cc: Hirokazu Takata <takata@linux-m32r.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: linux-m32r@ml.linux-m32r.org
> Cc: linux-m32r-ja@ml.linux-m32r.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
