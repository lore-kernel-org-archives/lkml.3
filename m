Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaGVOdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:33:14 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:38401 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbaGVOdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:33:07 -0400
MIME-Version: 1.0
In-Reply-To: <1405128084-15731-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1405128084-15731-1-git-send-email-bjorn.andersson@sonymobile.com>
Date: Tue, 22 Jul 2014 16:33:07 +0200
Message-ID: <CACRpkdZr6sWNW3Jb2zSmjyLP0h-0b32966f_NQiAE_s17DKFxQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: qcom: Make muxing of gpio function explicit
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 3:21 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:

> Instead of relying on pinmux->disable(), make the gpio function an
> explicit function for all pins that supports it.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Thanks, patch applied!

> This fixes the regression that was introduced by removing the disable function
> from the pinmux ops. I was exploiting the disable function to put the gpio pins
> "back" into gpio state and this was apparently not the right way to do things.

This is so much cleaner I think.

Please proceed to patch your DTS files for this as needed.

Yours,
Linus Walleij
