Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3AaIWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:22:46 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:43402 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3AaIWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:22:44 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CDD08C147402274194A8DDD9DBEF5593414954@SHSMSX101.ccr.corp.intel.com>
References: <1358987804.18561.22.camel@suxuemin.sh.intel.com>
	<87bocfugln.fsf@intel.com>
	<1359017171.18561.29.camel@suxuemin.sh.intel.com>
	<878v7juf2v.fsf@intel.com>
	<CDD08C147402274194A8DDD9DBEF5593414954@SHSMSX101.ccr.corp.intel.com>
Date: Thu, 31 Jan 2013 09:22:42 +0100
X-Google-Sender-Auth: w7S-nT2zOigMdIDHpE3EGJWNyE0
Message-ID: <CAKMK7uH3Og8Fi-w98BQtU61=B4cVzOv241L9eg9qHOekEUqs1w@mail.gmail.com>
Subject: Re: [PATCH V3] drm_crtc: check if fb_create return NULL
From: Daniel Vetter <daniel@ffwll.ch>
To: "Su, Xuemin" <xuemin.su@intel.com>, Dave Airlie <airlied@gmail.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, "He, Bo" <bo.he@intel.com>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 1:55 AM, Su, Xuemin <xuemin.su@intel.com> wrote:
> -----Original Message-----
> From: Jani Nikula [mailto:jani.nikula@linux.intel.com]
> Sent: Thursday, January 24, 2013 5:05 PM
> To: Su, Xuemin
> Cc: airlied@linux.ie; dri-devel@lists.freedesktop.org; linux-kernel@vger.kernel.org; yanmin_zhang@linux.intel.com; He, Bo
> Subject: Re: [PATCH V3] drm_crtc: check if fb_create return NULL
>
>>Ah, sorry, never mind, I missed Daniel's comment. The benefit of the
>>BUG_ON() is making it clear what's expected of the drivers.
>
>>Reviewed-by: Jani Nikula <jani.nikula@intel.com>
>
> Do you think this patch is still needed?
> Currently I fix a buggy function radeon_user_framebuffer_create() which returns NULL and patch is added to 3.7-stable tree.
> Do you think it's also needed to do something in drm_mode_addfb()?

Imo it's still useful, just to document the assumptions of the interface. Dave?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
