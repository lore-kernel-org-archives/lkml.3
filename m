Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab3ECQNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:13:35 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61244 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321Ab3ECQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:13:33 -0400
Date: Fri, 3 May 2013 18:16:37 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, dl9pf@gmx.de, airlied@linux.ie,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        pageexec@freemail.hu
Subject: Re: [Intel-gfx] [PATCH] [TRIVIAL] Fix declaration of
 intel_gmbus_{is_forced_bit/is_port_falid} in i915 driver.
Message-ID: <20130503161637.GM5763@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@linux.intel.com>, dl9pf@gmx.de,
	airlied@linux.ie, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	pageexec@freemail.hu
References: <1367572662-18400-1-git-send-email-dl9pf@gmx.de>
 <20130503092348.GL5763@phenom.ffwll.local>
 <87k3ngtgme.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k3ngtgme.fsf@intel.com>
X-Operating-System: Linux phenom 3.9.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 03:03:37PM +0300, Jani Nikula wrote:
> On Fri, 03 May 2013, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Fri, May 03, 2013 at 11:17:42AM +0200, dl9pf@gmx.de wrote:
> >> From: Jan-Simon Möller <dl9pf@gmx.de>
> >> 
> >> Description:
> >> intel_gmbus_is_forced_bit is no extern as its body is right below.
> >> Likewise for intel_gmbus_is_port_valid.
> >> 
> >> This fixes a compilation issue with clang. An initial version of this patch
> >> was developed by PaX Team <pageexec at freemail.hu>.
> >> This is respin of this patch.
> >> 
> >> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> >> CC: pageexec@freemail.hu
> >> CC: daniel.vetter@ffwll.ch
> >> CC: airlied@linux.ie
> >> CC: intel-gfx@lists.freedesktop.org
> >> CC: dri-devel@lists.freedesktop.org
> >> CC: linux-kernel@vger.kernel.org
> > Picked up for -fixes, thanks for the patch.
> 
> Please drop it.
> 
> The patch removes the inline keyword, creating dozens of copies of the
> functions, and consequently loads of warnings:
> 
> drivers/gpu/drm/i915/i915_drv.h:1803:13: warning: ‘intel_gmbus_is_port_valid’ defined but not used [-Wunused-function]
> drivers/gpu/drm/i915/i915_drv.h:1812:13: warning: ‘intel_gmbus_is_forced_bit’ defined but not used [-Wunused-function]

Meh, rather embarrassing patch reading fail here. Dropped.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
