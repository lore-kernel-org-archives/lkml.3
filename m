Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3GJGEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:04:16 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:37472 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3GJGEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:04:14 -0400
Date: Wed, 10 Jul 2013 08:04:14 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@intel.com>
Subject: Re: [Intel-gfx] [PATCH v2] Partially revert "drm/i915:
 unconditionally use mt forcewake on hsw/ivb"
Message-ID: <20130710060414.GF18285@phenom.ffwll.local>
Mail-Followup-To: Guenter Roeck <linux@roeck-us.net>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
	Mika Kuoppala <mika.kuoppala@intel.com>
References: <1373410831-1347-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373410831-1347-1-git-send-email-linux@roeck-us.net>
X-Operating-System: Linux phenom 3.10.0-rc5+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 04:00:31PM -0700, Guenter Roeck wrote:
> This patch partially reverts commit 36ec8f877481449bdfa072e6adf2060869e2b970 for
> IvyBridge CPUs.
> 
> The original commit results in repeated 'Timed out waiting for forcewake old
> ack to clear' messages on a Supermicro C7H61 board (BIOS version 2.00 and 2.00b)
> with i7-3770K CPU. It ultimately results in a hangup if the system is highly
> loaded. Reverting the commit for IvyBridge CPUs fixes the issue.
> 
> Issue a warning if the CPU is IvyBridge and mt forcewake is disabled, since
> this condition can result in secondary issues.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=60541
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Mika Kuoppala <mika.kuoppala@intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Picked up for -fixes, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
