Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaIKPXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:23:42 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:42007 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaIKPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:23:41 -0400
MIME-Version: 1.0
In-Reply-To: <1410421063-3028-1-git-send-email-zyw@rock-chips.com>
References: <1410421063-3028-1-git-send-email-zyw@rock-chips.com>
Date: Thu, 11 Sep 2014 08:23:40 -0700
X-Google-Sender-Auth: VEgnHe4pjJ1xdBHboB_trfxztGc
Message-ID: <CAD=FV=XFZdP66orf4nzrKN8owwibbFpHS3rE06a5Ti8eesakiA@mail.gmail.com>
Subject: Re: [PATCH v2] RTC: RK808: remove tm_def structure
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        zhangqing <zhangqing@rock-chips.com>, xxx <xxx@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Thu, Sep 11, 2014 at 12:37 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> If the date/time is invalid at bootup, there's no reason to set it to
> a bogus value. We can just let the data and time be invalid until
> someone makes it valid.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>

No need to resend, but as Mark Brown has mentioned before please don't
add spaces between tags.  Just jam them together.  Said another way:
no blank line between your Signed-off-by and my Reviewed-by.

-Doug
