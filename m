Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaCNPjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:39:39 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:42843 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbaCNPje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:39:34 -0400
MIME-Version: 1.0
In-Reply-To: <1394809576-21255-1-git-send-email-gdjakov@mm-sol.com>
References: <1394809576-21255-1-git-send-email-gdjakov@mm-sol.com>
Date: Fri, 14 Mar 2014 16:39:33 +0100
Message-ID: <CACRpkdbOZmqShCzOyczaTTjJzOU0WhfN1FuOBH-apARJs5AovA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: Fix compile error in msm_config_reg()
From: Linus Walleij <linus.walleij@linaro.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 4:06 PM, Georgi Djakov <gdjakov@mm-sol.com> wrote:

> Fix the following compilation error in msm_config_reg():
>
> drivers/pinctrl/pinctrl-msm.c: In function 'msm_config_reg':
> drivers/pinctrl/pinctrl-msm.c:218:4: error: 'reg' undeclared (first use in this
> function)
>
> Error is caused by the mix of these two commits:
> ed118a5fd951bd2def8249ee251842c4f81fe4bd
> 051a58b4622f0e1b732acb750097c64bc00ddb93
>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>

Thanks, but I already sent an identical fix earlier today!

Yours,
Linus Walleij
