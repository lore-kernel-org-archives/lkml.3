Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab3EPOMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:12:46 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:38771 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3EPOMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:12:45 -0400
MIME-Version: 1.0
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Date: Thu, 16 May 2013 07:12:44 -0700
X-Google-Sender-Auth: 73q13jQlP8fAaTub2t7Q8d81-Aw
Message-ID: <CA+55aFwJckiVkZWv1hFzXPR3fitT9uVq4RY8yGPaePK5zmAe+A@mail.gmail.com>
Subject: Re: [PATCH 00/11] sysv mqueue: do not hold the ipc lock unnecessarily
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 6:07 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> This patchset continues the work that began in the sysv ipc semaphore scaling

Looks fine to me, but with the problems we had on the semaphore side,
and since we're out of the merge window, I'm not going to take it into
3.10 (I assume you weren't expecting that either). But hopefully it
can go into Andrew''s -mm tree and get some testing.

              Linus
