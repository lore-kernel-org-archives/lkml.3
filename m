Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab3B0SJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:09:08 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:49564 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009Ab3B0SJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:09:05 -0500
MIME-Version: 1.0
In-Reply-To: <512E4954.6060601@linaro.org>
References: <1352665488-13818-1-git-send-email-mathieu.poirier@linaro.org>
	<20121119072525.GA16730@core.coreip.homeip.net>
	<CAPM=9tw8mefcYTqELXFbZWZ44a--SNcPnRMAvMSGTiODzRpDhg@mail.gmail.com>
	<CA+55aFysXNSJMHL-rKZ_fvPP3t357zTC-6hyHmh=S6K-Qx0WbQ@mail.gmail.com>
	<512E4954.6060601@linaro.org>
Date: Wed, 27 Feb 2013 10:09:04 -0800
X-Google-Sender-Auth: DidHcAguYc6PJKjXAMcDPEDSn74
Message-ID: <CA+55aFyGr5J2nPwgbX9U_6WPnwnQ6t2AKpnoxrEqerM5Yv+WqA@mail.gmail.com>
Subject: Re: [PATCH v4] drivers/tty: Folding Android's keyreset driver in sysRQ
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Dave Airlie <airlied@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arve@android.com, kernel-team@android.com,
        John Stultz <john.stultz@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 9:58 AM, Mathieu Poirier
<mathieu.poirier@linaro.org> wrote:
>
> Your fix is compiling, running and yielding the correct results -
> apologies about that.
>
> Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>

Ok, good. Committed and pushed out. Adding rmk and dhowells to the cc
just to let them know, since Dave said they were debugging this on
irc.

             Linus
