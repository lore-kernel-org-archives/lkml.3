Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab3CQV4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:56:39 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40567 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3CQV4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:56:38 -0400
Date: Sun, 17 Mar 2013 22:59:22 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "drm/i915: try to train DP even harder"
Message-ID: <20130317215922.GH9021@phenom.ffwll.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <s5h8v5tkf7j.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8v5tkf7j.wl%tiwai@suse.de>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 06:40:16PM +0100, Takashi Iwai wrote:
> This reverts commit 0d71068835e2610576d369d6d4cbf90e0f802a71.
> 
> Not only that the commit introduces a bogus check (voltage_tries == 5
> will never meet at the inserted code path), it brings the i915 driver
> into an endless dp-train loop on HP Z1 desktop machine with IVY+eDP.
> 
> At least reverting this commit recovers the framebuffer (but X is
> still broken by other reasons...)
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
Picked up for -fixes, thanks for the patch. Adding Paulo since it's his
patch. To assign proper blame please cc: relevant people when sending out
reverts.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
