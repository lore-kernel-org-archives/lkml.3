Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab3GQJ3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:29:45 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:57661 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3GQJ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:29:43 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130717091028.GA31187@localhost>
References: <51e63ed0.zKgIdwWoDkYbRWqH%fengguang.wu@intel.com>
	<20130717091028.GA31187@localhost>
Date: Wed, 17 Jul 2013 11:29:43 +0200
Message-ID: <CAKMK7uEPs-J+vmbc9rqw1FdV2mWucs1EyBB5NBeuqFZU0zz8Qw@mail.gmail.com>
Subject: Re: [drm-intel:drm-intel-fixes 52/52] ERROR: Unrecognized email
 address: 'stable.]'
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, kbuild-all@01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 11:10 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> Hi Konstantin,
>
> FYI, there are new warnings show up in
>
> tree:   git://people.freedesktop.org/~danvet/drm-intel.git drm-intel-fixes
> head:   71e4092e52499ec74bc1dec0f883b15f2c424ec5
> commit: 71e4092e52499ec74bc1dec0f883b15f2c424ec5 [52/52] drm/i915: fix long-standing SNB regression in power consumption after resume v2
>
> scripts/checkpatch.pl 0001-drm-i915-fix-long-standing-SNB-regression-in-power-c.patch
>
> ERROR: Unrecognized email address: 'stable.]'
> #41:
> cc: stable.]

Well, I've added that while applying the patch - I tend to smash
maintainer notes into the sob section and word-wraping caused the cc:
stable remark to be parsed. Is there an officially sanctioned way for
such notes that appeases checkpatch? Adding lkml and checkpatch
maintainer.
-Daniel


> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation



--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
