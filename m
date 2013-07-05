Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab3GEKE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:04:28 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:38565 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab3GEKE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:04:27 -0400
MIME-Version: 1.0
In-Reply-To: <874nc9zpta.fsf@sejong.aot.lge.com>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com> <874nc9zpta.fsf@sejong.aot.lge.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 5 Jul 2013 15:33:46 +0530
Message-ID: <CALkWK0=8j8FBhMLJFT5Rd49Bfb4jkLs6LwtJd5QnFr0c-c05fw@mail.gmail.com>
Subject: Re: [PATCH 0/7] Minor perf completion improvements
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim wrote:
> So the whole point of this patchset is removing dependency, and no
> functional change, right?

Yep, and to lay the groundwork for extensibility: I would like to add
ZSH support in a future patchset, for instance.

> It'd be great if the completion script supports multiple events
> separated by comma esp. in a group syntax (i.e. surrounded be a pair of
> curly braces: -e '{cache-references,cache-misses}').  Could you take a
> look at that if possible?

Sure, thanks.
