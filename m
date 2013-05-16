Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3EPQlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:41:23 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:47409 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3EPQlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:41:22 -0400
Message-ID: <1368722480.1763.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 00/11] sysv mqueue: do not hold the ipc lock
 unnecessarily
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 May 2013 09:41:20 -0700
In-Reply-To: <CA+55aFwJckiVkZWv1hFzXPR3fitT9uVq4RY8yGPaePK5zmAe+A@mail.gmail.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
	 <CA+55aFwJckiVkZWv1hFzXPR3fitT9uVq4RY8yGPaePK5zmAe+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 07:12 -0700, Linus Torvalds wrote:
> On Wed, May 15, 2013 at 6:07 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> > This patchset continues the work that began in the sysv ipc semaphore scaling
> 
> Looks fine to me, but with the problems we had on the semaphore side,
> and since we're out of the merge window, I'm not going to take it into
> 3.10 (I assume you weren't expecting that either). But hopefully it
> can go into Andrew''s -mm tree and get some testing.

Yes, it is intended for Andrew's tree.

