Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaLQT6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:58:49 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36620 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLQT6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:58:45 -0500
MIME-Version: 1.0
In-Reply-To: <5491D0D2.5070103@sr71.net>
References: <5490A5F8.6050504@sr71.net>
	<20141217100810.GA3461@arm.com>
	<CA+55aFyVxOw0upa=At6MmiNYEHzfPz4rE5bZUBCs9h4vKGh1iA@mail.gmail.com>
	<20141217165310.GJ870@arm.com>
	<5491D0D2.5070103@sr71.net>
Date: Wed, 17 Dec 2014 11:58:44 -0800
X-Google-Sender-Auth: qOe-Evx1UeTdWJ1KpuDzS9QIWHM
Message-ID: <CA+55aFze3z_f4hKKg3mf3YcQX6KyDfMO7UmUUhjWx5dtjQZN1A@mail.gmail.com>
Subject: Re: post-3.18 performance regression in TLB flushing code
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Hansen <dave@sr71.net>
Cc: Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Simek <monstr@monstr.eu>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 10:52 AM, Dave Hansen <dave@sr71.net> wrote:
>
> These things are also a little bit noisy, so we're well within the
> margin of error with Linus's fix.
>
> This also holds up on the large system.

Good. I'll commit it asap.

                          Linus
