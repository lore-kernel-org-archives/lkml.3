Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab3GZDca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:32:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39274 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452Ab3GZDcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:32:10 -0400
Message-ID: <51F1ED8F.40703@zytor.com>
Date: Thu, 25 Jul 2013 20:31:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: mingo@kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: Ugly patches for stolen reservation
References: <rddfy5e894xuv6d47gu7hbuh.1374804892449@email.android.com>
In-Reply-To: <rddfy5e894xuv6d47gu7hbuh.1374804892449@email.android.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 07:14 PM, Jesse Barnes wrote:
> To clarify: it'll either be marked reserved or not listed at all in e820, which is why I did this early, before any other e820 stuff like the "RAM buffer" are allocated, and before we could use the iomem resource (or maybe we could even early per Linus? I'll check). 
> 
> Jesse

If it is marked reserved or not listed at all it is much less of an
issue.  Reserved is in fact the correct thing; not listed at all really
isn't very problematic in most cases.

	-hpa


