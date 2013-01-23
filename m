Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3AWJ4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:56:37 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:63052 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3AWJ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:56:35 -0500
Date: Wed, 23 Jan 2013 10:53:37 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: "Su, Xuemin" <xuemin.su@intel.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        bo.he@intel.com
Subject: Re: [PATCH V2 RESEND] drm_crtc: check if fb_create return NULL
Message-ID: <20130123095337.GQ31870@phenom.ffwll.local>
Mail-Followup-To: "Su, Xuemin" <xuemin.su@intel.com>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	yanmin_zhang@linux.intel.com, bo.he@intel.com
References: <1358911167.18561.20.camel@suxuemin.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358911167.18561.20.camel@suxuemin.sh.intel.com>
X-Operating-System: Linux phenom 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 11:19:27AM +0800, Su, Xuemin wrote:
> From: xueminsu <xuemin.su@intel.com>
> Date: Tue, 22 Jan 2013 22:39:39 +0800
> Subject: [PATCH] drm_crtc: check if fb_create return NULL
> 
> Some buggy driver may still return NULL in fb_create,
> which leads to kernel panic.
> 
> Signed-off-by: xueminsu <xuemin.su@intel.com>

Imo just BUG_ON(!fb); and call it a day. Makes it pretty clear what's
expected of the drivers.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
