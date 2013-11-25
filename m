Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3KYI6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:58:09 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50508 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3KYI6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:58:03 -0500
Date: Mon, 25 Nov 2013 09:58:43 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Levente Kurusa <levex@linux.com>
Cc: Arthur Schwalbenberg <aschwal@hotmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Arthur Schwalbenberg <arthurs578@gmail.com>
Subject: Re: Patch
Message-ID: <20131125085843.GX27344@phenom.ffwll.local>
Mail-Followup-To: Levente Kurusa <levex@linux.com>,
	Arthur Schwalbenberg <aschwal@hotmail.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Arthur Schwalbenberg <arthurs578@gmail.com>
References: <BLU0-SMTP55275B8B1932509DE4677AACE00@phx.gbl>
 <528F9630.6090202@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <528F9630.6090202@linux.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 06:36:48PM +0100, Levente Kurusa wrote:
> 2013-11-22 17:35, Arthur Schwalbenberg:
> > 
> > From 340fa01dfe8f699e27ece111996ea088bca6b5c4 Mon Sep 17 00:00:00 2001
> > From: Arthur Schwalbenberg <aschwal@hotmail.com>
> > Date: Thu, 21 Nov 2013 19:42:44 -0500
> > Subject: [PATCH] Staging: Fixed compilar warnings and coding style
> > issues in i915_debugfs.c
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> > 
> > This is a patch fixing both a compilar warning:
> > ‘val’ may be used uninitialized in this function
> > and various coding style issues which include line length
> > warnings and a few errors as defined by 'checkpatch.pl' tool
> > 
> > Signed-off-by: Arthur Schwalbenberg <aschwal@hotmail.com>
> 
> Hi,
> 
> When you break 80+ lines into two lines, you should also
> indent the newly created line so that it shows that it is a part of something.
> I as well don't think it is worth splitting lines that are 84 characters long into
> two lines, that just doesn't make sense.
> 
> Also, your patch seems (atleast to me) a 'bit' whitespace damaged.

Also, please don't smash different changes into the same patch. Especially
pure whitespace changes _must_ be separate from actual code changes.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
