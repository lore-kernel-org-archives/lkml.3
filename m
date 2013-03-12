Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3CLAUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:20:11 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:32966 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3CLAUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:20:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130311230330.GC3872@bremse>
References: <20130310211006.GA26200@www.outflux.net>
	<20130311230330.GC3872@bremse>
Date: Mon, 11 Mar 2013 17:20:08 -0700
X-Google-Sender-Auth: 1mzs26yd3oNFWKz6xayTUkhAm2c
Message-ID: <CAGXu5jK_=5eqyLX=UsXUAOtmcWGuXBw8MC5HxL0FBCn7GJnEug@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: use simple attribute in debugfs routines
From: Kees Cook <keescook@chromium.org>
To: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 4:03 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Sun, Mar 10, 2013 at 02:10:06PM -0700, Kees Cook wrote:
>> This replaces the manual read/write routines in debugfs with the common
>> simple attribute helpers. Doing this gets rid of repeated copy/pasting
>> of copy_from_user and value formatting code.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> Queued for -next, thanks for the patch. When sending drm/i915 patches,
> please also cc intel-gfx@lists.freedesktop.org (it's open for
> non-subscribers non without nagging "you're mail is in the moderation
> queue" replies).

Ah-ha, sure.

Should MAINTAINERS be updated to reflect this? It got skipped as a
destination due to the "subscribers-only" suffix.

-Kees

-- 
Kees Cook
Chrome OS Security
