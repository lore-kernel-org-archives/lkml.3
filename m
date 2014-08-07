Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaHGEF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 00:05:28 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:41410 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaHGEF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 00:05:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1408061125180.9718@pobox.suse.cz>
References: <alpine.LNX.2.00.1408061125180.9718@pobox.suse.cz>
Date: Wed, 6 Aug 2014 21:05:26 -0700
X-Google-Sender-Auth: AUjovzUgQsupvJMb-sUj4MET-Aw
Message-ID: <CA+55aFxv7iRwmqsDV2FHvt9g0GVKbOtr4cOUVyRY45ufAh+hSw@mail.gmail.com>
Subject: Re: [GIT PULL] trivial for 3.17
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 2:37 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> You are going to get two conflicts super-easy to resolve:
>
> - arch/arm/mach-msm/Kconfig removal of unused MSM_SCM config value
>   conflicts with addition of MSM_TIMER to the same spot; resolution is to
>   keep MSM_TIMER and remove MSM_SCM

That's not right. Both MSM_TIMER and MSM_SCM went away.

> - Documentation/laptops/hpfall.c conflict easy to resolve by

Looks correct.

         Linus
