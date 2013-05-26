Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3EZRhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 13:37:20 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:34678 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3EZRhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 13:37:19 -0400
MIME-Version: 1.0
In-Reply-To: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
Date: Sun, 26 May 2013 10:37:18 -0700
X-Google-Sender-Auth: euEIiMxUjCFvkikZmWZpsOW50D0
Message-ID: <CA+55aFzg7mtUiNWgxz1zo-rrpSceWmkqyw_CwXyEjHVzV-n_LQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] ipc/sem.c: Bug fixes, regression fixes, v3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Hai Huang <hhuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 2:08 AM, Manfred Spraul
<manfred@colorfullife.com> wrote:
> I've split my patch into 4 parts:
> - 1: Fix-missing-wakeups-in-do_smart_update
> - 2: seperate-wait-for-zero-and-alter-tasks
> - 3: Always-use-only-one-queue-for-alter-operations
> - 4: Rename-try_atomic_semop-to-perform_atomic

Rik, Davidlohr, acks/reviews please?

                Linus
