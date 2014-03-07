Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaCGQFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:05:37 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:34924 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaCGQFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:05:36 -0500
MIME-Version: 1.0
In-Reply-To: <1394174686-8358-1-git-send-email-sboyd@codeaurora.org>
References: <1394174686-8358-1-git-send-email-sboyd@codeaurora.org>
Date: Fri, 7 Mar 2014 08:05:35 -0800
Message-ID: <CAJAp7OhjkdW92PKk8xwkHSLx260Y_--ed5cePrk6cMe=k3RAXA@mail.gmail.com>
Subject: Re: [PATCH 0/7] pinctrl-msm cleanups
From: Bjorn Andersson <bjorn@kryo.se>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 10:44 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Here are some small fixes and cleanups for the msm pinctrl
> driver.
>
> Stephen Boyd (7):
>   pinctrl: msm: Silence recursive lockdep warning
>   pinctrl: msm: Check for ngpios > MAX_NR_GPIO
>   pinctrl: msm: Drop unused includes
>   pinctrl: msm: Drop OF_IRQ dependency
>   pinctrl: msm: Replace lookup tables with math
>   pinctrl: msm: Remove impossible WARN_ON()s
>   pinctrl: msm: Simplify msm_config_reg() and callers
>
>  drivers/pinctrl/Kconfig           |  2 +-
>  drivers/pinctrl/pinctrl-msm.c     | 73 ++++++++++++++-------------------------
>  drivers/pinctrl/pinctrl-msm.h     |  5 +--
>  drivers/pinctrl/pinctrl-msm8x74.c |  1 -
>  4 files changed, 27 insertions(+), 54 deletions(-)

Looks good

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
