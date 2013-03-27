Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab3C0Vrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:47:35 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:44531 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3C0Vrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:47:32 -0400
MIME-Version: 1.0
In-Reply-To: <1363322223-19850-2-git-send-email-sachin.kamat@linaro.org>
References: <1363322223-19850-1-git-send-email-sachin.kamat@linaro.org>
	<1363322223-19850-2-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 27 Mar 2013 22:47:31 +0100
Message-ID: <CACRpkdYznVCHY1VJ+YtBT5NOS4AQRCc3poRTfeFmX4Qx99brhA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: at91: Fix checkpatch errors
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 5:37 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> Fixes the following types of checkpatch errors:
> ERROR: "foo * bar" should be "foo *bar"
> ERROR: "foo* bar" should be "foo *bar"
> ERROR: space required before the open parenthesis '('
> ERROR: "(foo*)" should be "(foo *)"
> ERROR: space required after that ',' (ctx:WxV)
> ERROR: "(foo*const*)" should be "(foo *const*)"
> ERROR: space required before that '*' (ctx:VxB)
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied!

Thanks,
Linus Walleij
