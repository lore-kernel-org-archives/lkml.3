Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263Ab3CMU3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:29:05 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:44146 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMU3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:29:03 -0400
Date: Wed, 13 Mar 2013 21:28:58 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Julien Tinnes <jln@google.com>,
        marcheu@chromium.org
Subject: Re: [PATCH v3] drm/i915: bounds check execbuffer relocation count
Message-ID: <20130313202858.GD1896@bremse>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, Julien Tinnes <jln@google.com>,
	marcheu@chromium.org
References: <20130312003145.GA28993@www.outflux.net>
 <20130312090746.GD31324@cantiga.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312090746.GD31324@cantiga.alporthouse.com>
X-Operating-System: Linux bremse 3.8.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 09:07:46AM +0000, Chris Wilson wrote:
> On Mon, Mar 11, 2013 at 05:31:45PM -0700, Kees Cook wrote:
> > It is possible to wrap the counter used to allocate the buffer for
> > relocation copies. This could lead to heap writing overflows.
> > 
> > CVE-2013-0913
> > 
> > v3: collapse test, improve comment
> > v2: move check into validate_exec_list
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Reported-by: Pinkie Pie
> > Cc: stable@vger.kernel.org
> 
> Looks good to me. The only bikeshed that remains is whether we should
> just collapse the two variables into one, but the current 'max - count'
> is more idiomatic and so preferrable.
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>

Picked up for -fixes, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
