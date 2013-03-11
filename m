Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3CKXSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:18:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39383 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3CKXS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:18:28 -0400
Date: Tue, 12 Mar 2013 00:18:21 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: restrict kernel address leak in debugfs
Message-ID: <20130311231821.GE3872@bremse>
Mail-Followup-To: Kees Cook <keescook@chromium.org>,
	linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org
References: <20130311192519.GA18185@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311192519.GA18185@www.outflux.net>
X-Operating-System: Linux bremse 3.8.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:25:19PM -0700, Kees Cook wrote:
> Masks kernel address info-leak in object dumps with the %pK suffix,
> so they cannot be used to target kernel memory corruption attacks if
> the kptr_restrict sysctl is set.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
Picked up for -fixes, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
