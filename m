Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305Ab3BTB7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:59:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48239 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab3BTB7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:59:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130219141642.GA12928@gmail.com>
References: <20130219141642.GA12928@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Feb 2013 17:59:01 -0800
X-Google-Sender-Auth: rSx6VMA_5u0lw6SlaK9ppFLOwkU
Message-ID: <CA+55aFwR=p9YL0UKo3E_e1PRZvga8TeWLbqQGvwTzKGaazHrvA@mail.gmail.com>
Subject: Re: [GIT PULL] perf fix for v3.9
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 6:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest perf-urgent-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
>
>    HEAD: e97cbe3edf7d88aad4c21dd3de124d9f9d039881 perf/hwbp: Fix cleanup in case of kzalloc() failure
>
> Leftover fix from the v3.8 cycle.

This was already in the other (big) perf pull, as commit 02e176af92f3

                 Linus
