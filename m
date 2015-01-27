Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbbA0Ja5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:30:57 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35907 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbbA0Jaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:30:52 -0500
Date: Tue, 27 Jan 2015 10:30:19 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Kumar Amit Mehta <gmate.amit@gmail.com>, daniel.vetter@intel.com,
        airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drivers: gpu: drm: i915:
 intel_fifo_underrun.c: Fix a typo in comment
Message-ID: <20150127093019.GM10113@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@linux.intel.com>,
	Kumar Amit Mehta <gmate.amit@gmail.com>, daniel.vetter@intel.com,
	airlied@linux.ie, intel-gfx@lists.freedesktop.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <1422290852-4060-1-git-send-email-gmate.amit@gmail.com>
 <87siewfygu.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siewfygu.fsf@intel.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 09:56:49AM +0200, Jani Nikula wrote:
> On Mon, 26 Jan 2015, Kumar Amit Mehta <gmate.amit@gmail.com> wrote:
> > The comment for intel_cpu_fifo_underrun_irq_handler() is not consistent
> > with the code and the rest of the comment for this routine. This patch
> > fixes this typo in comment.
> >
> > Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> 
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>

Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
