Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaLJAln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 19:41:43 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:55779 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaLJAll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 19:41:41 -0500
MIME-Version: 1.0
In-Reply-To: <1418133106-5634-2-git-send-email-zyw@rock-chips.com>
References: <1418133106-5634-1-git-send-email-zyw@rock-chips.com>
	<1418133106-5634-2-git-send-email-zyw@rock-chips.com>
Date: Tue, 9 Dec 2014 16:41:40 -0800
X-Google-Sender-Auth: CcJ14xMniu_xxxsK5YIavZqtHVI
Message-ID: <CAD=FV=UoQ2j01Yt_xAWVG+qP_b6jE7fPzX7SGoZUse0QyUdXQA@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: rk808: add dvs support
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Dec 9, 2014 at 5:51 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> +       /* dvsok pin would be pull down when dvs1/2 pin changed, and
> +        * it would be pull up once the voltage regulate complete.
> +        * No need to wait dvsok signal when voltage falling.
> +        */

A tiny nit that I think standard multiline commenting style should
make the above:

+       /*
+        * dvsok pin would be pull down when dvs1/2 pin changed, and
+        * it would be pull up once the voltage regulate complete.
+        * No need to wait dvsok signal when voltage falling.
+        */

...but I'll leave it up to broonie@ if he cares...

Given that I've privately reviewed an earlier version of this before
you sent it up, it's not surprising that I have no other comments, so:

Reviewed-by: Doug Anderson <dianders@chromium.org>

:)

-Doug
