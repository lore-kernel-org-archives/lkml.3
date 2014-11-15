Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaKOBh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:37:29 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:57022 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaKOBh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:37:27 -0500
MIME-Version: 1.0
In-Reply-To: <1415985002-28144-1-git-send-email-will.deacon@arm.com>
References: <1415985002-28144-1-git-send-email-will.deacon@arm.com>
Date: Fri, 14 Nov 2014 17:37:26 -0800
X-Google-Sender-Auth: RX6Hura_dRy2GTJpvuOXnfHstaI
Message-ID: <CA+55aFwANkY7PVmk0U=40AS29bBUOQCm-oDW5HOcnz_gO+gc2A@mail.gmail.com>
Subject: Re: [PATCH] mmu_gather: move minimal range calculations into generic code
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Simek <monstr@monstr.eu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 9:10 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>

Make that an Acked-by, it still looks fine to me.

               Linus
