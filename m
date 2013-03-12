Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3CLFq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:46:59 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:32768 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3CLFq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:46:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130312152226.c5965a68f57444c8652eb46a@canb.auug.org.au>
References: <20130312152226.c5965a68f57444c8652eb46a@canb.auug.org.au>
Date: Mon, 11 Mar 2013 22:46:56 -0700
X-Google-Sender-Auth: cm6-fmpgAdpt9piUBdDpOA7IVng
Message-ID: <CAGXu5jJm2QM-s6DV3e5guQc5i-qEK52uRR6xc=ViqrvCibHEUw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (drm-intel tree related)
From: Kees Cook <keescook@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Linux-Next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 9:22 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (i386 defconfig)
> failed like this:
>
> drivers/built-in.o: In function `i915_min_freq_set':
> i915_debugfs.c:(.text+0xb1adc): undefined reference to `__udivdi3'
> drivers/built-in.o: In function `i915_max_freq_set':
> i915_debugfs.c:(.text+0xb1bac): undefined reference to `__udivdi3'
>
> Caused by commit 2389cc500686 ("drm/i915: use simple attribute in debugfs
> routines") from the drm-intel tree.
>
> I have reverted that commit for today.

Ah-ha, thanks. I've sent a follow-up patch to fix this.

-Kees

-- 
Kees Cook
Chrome OS Security
