Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab3CKVEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:04:53 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:42267 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3CKVEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:04:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130311205125.GA31324@cantiga.alporthouse.com>
References: <20130311192630.GA18227@www.outflux.net>
	<20130311205125.GA31324@cantiga.alporthouse.com>
Date: Mon, 11 Mar 2013 14:04:51 -0700
X-Google-Sender-Auth: LdqK630n2UgFr3fdPsjFW3ombDc
Message-ID: <CAGXu5j+v9ma5rwhtPqtJKzve5q5G_m9VQkAUqJ38VnDFPpvGYw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: clarify reasoning for the access_ok call
From: Kees Cook <keescook@chromium.org>
To: Chris Wilson <chris@chris-wilson.co.uk>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 1:51 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Mon, Mar 11, 2013 at 12:26:30PM -0700, Kees Cook wrote:
>> This clarifies the comment above the access_ok check so a missing
>> VERIFY_READ doesn't alarm anyone.
>
> Do we really need to copy the interface documentation?
>
> /**
>  * access_ok: - Checks if a user space pointer is valid
>  * @type: Type of access: %VERIFY_READ or %VERIFY_WRITE.  Note that
>  *        %VERIFY_WRITE is a superset of %VERIFY_READ - if it is safe
>  *        to write to a block, it is always safe to read from it.
>  * @addr: User space pointer to start of block to check
>  * @size: Size of block to check
>  */
> -Chris

Probably not. It just seemed like the existing comment was
insufficient after the removal of the redundant VERIFY_READ check that
happened recently.

-Kees

-- 
Kees Cook
Chrome OS Security
