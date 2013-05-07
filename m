Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3EGKhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:37:22 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:65066 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab3EGKhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:37:20 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130507112751.195757b78defdbea58aa6134@canb.auug.org.au>
References: <20130507112751.195757b78defdbea58aa6134@canb.auug.org.au>
Date: Tue, 7 May 2013 10:43:17 +0200
Message-ID: <CAKMK7uEr4Fs00nM3iuwwBdd+LV3_6w2sarR+i8tk02BrTHQmNA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the drm-intel tree with Linus' tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 3:27 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the drm-intel tree got a conflict in
> drivers/gpu/drm/i915/i915_reg.h between commit a65851af5938 ("drm/i915:
> Make data/link N value power of two") from Linus' tree and commit
> e3b95f1eb5b9 ("drm/i915: Apply OCD to data/link m/n register #defines")
> from the drm-intel tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>
> Daniel, I assume all this stuff being added to the drm-intel tree is
> going upstream very soon?

Oops, no that is stuff for 3.11. Lazy me hoped I could sneak stuff
through (since we just keep on merging features to
drm-intel-next-queued to avoid stalls), but that's obviously not what
you want for linux-next. My apologies for that mess. I've now created
a for-linux-next branch which will not contain patches heading for
3.x+1 while 3.x-rc1 hasn't been released yet.

Can you please switch over to that branch for inclusion into linux-next?

Yours, Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
