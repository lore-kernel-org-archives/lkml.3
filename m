Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762940Ab3ECJUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:20:45 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59673 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3ECJUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:20:43 -0400
Date: Fri, 3 May 2013 11:23:48 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: dl9pf@gmx.de
Cc: pageexec@freemail.hu, daniel.vetter@ffwll.ch, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Fix declaration of
 intel_gmbus_{is_forced_bit/is_port_falid} in i915 driver.
Message-ID: <20130503092348.GL5763@phenom.ffwll.local>
Mail-Followup-To: dl9pf@gmx.de, pageexec@freemail.hu, airlied@linux.ie,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1367572662-18400-1-git-send-email-dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367572662-18400-1-git-send-email-dl9pf@gmx.de>
X-Operating-System: Linux phenom 3.9.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 11:17:42AM +0200, dl9pf@gmx.de wrote:
> From: Jan-Simon Möller <dl9pf@gmx.de>
> 
> Description:
> intel_gmbus_is_forced_bit is no extern as its body is right below.
> Likewise for intel_gmbus_is_port_valid.
> 
> This fixes a compilation issue with clang. An initial version of this patch
> was developed by PaX Team <pageexec at freemail.hu>.
> This is respin of this patch.
> 
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> CC: pageexec@freemail.hu
> CC: daniel.vetter@ffwll.ch
> CC: airlied@linux.ie
> CC: intel-gfx@lists.freedesktop.org
> CC: dri-devel@lists.freedesktop.org
> CC: linux-kernel@vger.kernel.org
Picked up for -fixes, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
