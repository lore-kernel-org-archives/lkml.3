Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab3H2Uje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:39:34 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:62577 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab3H2Ujc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:39:32 -0400
Date: Thu, 29 Aug 2013 22:39:42 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 3/6] i915_gem: Convert kmem_cache_alloc(...GFP_ZERO) to
 kmem_cache_zalloc
Message-ID: <20130829203942.GB32184@phenom.ffwll.local>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
References: <cover.1377806578.git.joe@perches.com>
 <d846a338b419b2f3b8f2ac61db01e3faa5b2f832.1377806578.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d846a338b419b2f3b8f2ac61db01e3faa5b2f832.1377806578.git.joe@perches.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 01:11:07PM -0700, Joe Perches wrote:
> The helper exists, might as well use it instead of __GFP_ZERO.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
