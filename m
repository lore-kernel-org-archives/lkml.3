Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab3DKUa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:30:57 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52602 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab3DKUaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:30:22 -0400
MIME-Version: 1.0
In-Reply-To: <1365711890-15168-1-git-send-email-abrestic@chromium.org>
References: <1365705391-23181-1-git-send-email-abrestic@chromium.org>
	<1365711890-15168-1-git-send-email-abrestic@chromium.org>
Date: Thu, 11 Apr 2013 13:30:20 -0700
X-Google-Sender-Auth: jQerUIhst5FLeT7Eci09mddS1Sg
Message-ID: <CAD=FV=UJ7rTa1VQXb=DT1MJkNGxQkkoYiQLXAx7+sg7u0E0gNg@mail.gmail.com>
Subject: Re: [PATCH v2] backlight: platform_lcd: introduce probe callback
From: Doug Anderson <dianders@chromium.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: linux-fbdev@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Thu, Apr 11, 2013 at 1:24 PM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> Platform LCD devices may need to do some device-specific
> initialization before they can be used (regulator or GPIO setup,
> for example), but currently the driver does not support any way of
> doing this.  This patch adds a probe() callback to plat_lcd_data
> which platform LCD devices can set to indicate that device-specific
> initialization is needed.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  drivers/video/backlight/platform_lcd.c | 6 ++++++
>  include/video/platform_lcd.h           | 1 +
>  2 files changed, 7 insertions(+)

Reviewed-by: Doug Anderson <dianders@chromium.org>
