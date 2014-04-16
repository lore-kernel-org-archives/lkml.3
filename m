Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbaDPXEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:04:43 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:42690 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbaDPXEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:04:40 -0400
MIME-Version: 1.0
In-Reply-To: <534E4775.8010009@ti.com>
References: <534E4775.8010009@ti.com>
Date: Wed, 16 Apr 2014 16:04:39 -0700
X-Google-Sender-Auth: dy0f0JN72s382y1oTB1iN-HS710
Message-ID: <CA+55aFz7Hgjc9wmiriqGT8VXNF-7b0aUKf96r=TCP+1NOTSVeQ@mail.gmail.com>
Subject: Re: [GIT PULL] fbdev fixes for 3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 2:03 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>
> The drivers/video/Kconfig change in this pull request will conflict with the
> fbdev reorder series, which is not yet in your tree. If that's an issue, I can
> resend this without the Kconfig change.

I was actually hoping/expecting you to just resend the renaming
rebased on top of 3.15-rc1. Or maybe you could do it on top of this.

            Linus
