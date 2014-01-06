Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaAFJz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:55:58 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:61198 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaAFJzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:55:55 -0500
Date: Mon, 6 Jan 2014 10:57:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: chris@chris-wilson.co.uk, ben@bwidawsk.net, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH] drm/i915: Fix refcount leak and possible NULL pointer
 dereference.
Message-ID: <20140106095706.GA16015@phenom.ffwll.local>
Mail-Followup-To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	chris@chris-wilson.co.uk, ben@bwidawsk.net,
	linux-kernel@vger.kernel.org,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>
References: <201312242050.CGH78112.JQFOSVMLOFtHOF@I-love.SAKURA.ne.jp>
 <20131225215249.GA3832@nuc-i3427.alporthouse.com>
 <201401032042.BJF09317.FJFQOFOVtSOLMH@I-love.SAKURA.ne.jp>
 <20140103125151.GA4367@nuc-i3427.alporthouse.com>
 <201401051008.FFH69706.JLOVMFFSQFHOOt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401051008.FFH69706.JLOVMFFSQFHOOt@I-love.SAKURA.ne.jp>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 10:08:42AM +0900, Tetsuo Handa wrote:
> Chris Wilson wrote:
> > > Then, this file->pid in &dev->filelist keeps at least one reference.
> > > OK. Updated patch follows.
> > 
> > Looks good to me, and the comment is great.
> > -Chris
> 
> Please pick up this patch via your git tree.
> 
> Also, please change from "<unknown>" to whatever you like. For example,
> dump_holder() in fs/gfs2/glock.c uses "(ended)" if comm is not available.

Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
