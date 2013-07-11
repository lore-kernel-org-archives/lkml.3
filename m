Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3GKTdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:33:40 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51542 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3GKTdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:33:39 -0400
MIME-Version: 1.0
In-Reply-To: <51def42d.829c420a.642f.5775@mx.google.com>
References: <51def42d.829c420a.642f.5775@mx.google.com>
Date: Thu, 11 Jul 2013 12:33:38 -0700
X-Google-Sender-Auth: iN5Det72gPes8ot0U68kRHaw0o0
Message-ID: <CA+55aFxqXHvDqWO7rqqL6PExsEXn6kfUKRnPFsg89SRq_a74Hw@mail.gmail.com>
Subject: Re: [GIT PULL] xtensa: patchset for v3.11-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Zankel <chris@zankel.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 11:06 AM,  <chris@zankel.net> wrote:
> Hi Linus,
>
> Would be great if you could pull the Xtensa tree. Some of the changes were
> dependent on the timers-core patchset, hence the 'merge' message
> (I think that's the right way to do it?)

Grr. I hate it when people do this. Your merge message sucks. It just
says "Merge branch .." without explaining what the merge does and
*why* it does it.

We have a policy of good commit messages in the kernel.  That is
*doubly* true for cross-subsystem merges that can be so much harder to
understand, and really need very explicit reasons for existing in the
first place.

I've pulled this, but please avoid doing things like this in the future..

              Linus
