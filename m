Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab3CMUXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:23:45 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41640 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3CMUXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:23:44 -0400
Date: Wed, 13 Mar 2013 21:23:22 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (drm-intel tree related)
Message-ID: <20130313202322.GC1896@bremse>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
References: <20130312152226.c5965a68f57444c8652eb46a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312152226.c5965a68f57444c8652eb46a@canb.auug.org.au>
X-Operating-System: Linux bremse 3.8.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 03:22:26PM +1100, Stephen Rothwell wrote:
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

Should be fixed now, thanks for the report (and my apologies for the
little screw-up).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
