Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935549Ab3BOJaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:30:21 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:51093 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3BOJaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:30:17 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130215133714.6f55139ad1a037b7b9fa1b70@canb.auug.org.au>
References: <20130215133714.6f55139ad1a037b7b9fa1b70@canb.auug.org.au>
Date: Fri, 15 Feb 2013 10:30:16 +0100
Message-ID: <CAKMK7uGG4R68ED4M1uYRUZAhxRMzao0vk9oFg_vxZ8ofhx1=yw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the drm-intel tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Barnes, Jesse" <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 3:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the drm-intel tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "pm_vt_switch_unregister" [drivers/video/fb.ko] undefined!
>
> I have dropped the tree for today.

Meh, that fail was already reported from Wu's kernel builder a few
days ago, but no patch yet showed up to fix things. Since the i915
side of that work isn't ready yet either I've dropped the offending
patches.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
