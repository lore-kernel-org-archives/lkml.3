Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3KVRgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:36:52 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:35062 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab3KVRgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:36:51 -0500
Message-ID: <528F9630.6090202@linux.com>
Date: Fri, 22 Nov 2013 18:36:48 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arthur Schwalbenberg <aschwal@hotmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Arthur Schwalbenberg <arthurs578@gmail.com>
Subject: Re: Patch
References: <BLU0-SMTP55275B8B1932509DE4677AACE00@phx.gbl>
In-Reply-To: <BLU0-SMTP55275B8B1932509DE4677AACE00@phx.gbl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-22 17:35, Arthur Schwalbenberg:
> 
> From 340fa01dfe8f699e27ece111996ea088bca6b5c4 Mon Sep 17 00:00:00 2001
> From: Arthur Schwalbenberg <aschwal@hotmail.com>
> Date: Thu, 21 Nov 2013 19:42:44 -0500
> Subject: [PATCH] Staging: Fixed compilar warnings and coding style
> issues in i915_debugfs.c
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> This is a patch fixing both a compilar warning:
> ‘val’ may be used uninitialized in this function
> and various coding style issues which include line length
> warnings and a few errors as defined by 'checkpatch.pl' tool
> 
> Signed-off-by: Arthur Schwalbenberg <aschwal@hotmail.com>

Hi,

When you break 80+ lines into two lines, you should also
indent the newly created line so that it shows that it is a part of something.
I as well don't think it is worth splitting lines that are 84 characters long into
two lines, that just doesn't make sense.

Also, your patch seems (atleast to me) a 'bit' whitespace damaged.

-- 
Regards,
Levente Kurusa
