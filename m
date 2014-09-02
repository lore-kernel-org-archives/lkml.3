Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaIBMb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:31:59 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:60655 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaIBMb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <1409322659-17693-4-git-send-email-pramod.gurav@smartplayin.com>
References: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>
	<1409322659-17693-4-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 2 Sep 2014 14:31:56 +0200
Message-ID: <CACRpkdbrtf83-iYuX6LnOA_56Jnkv82JX77b1WQtipogaMSHwg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] pinctrl: msm: Add ps_hold function in
 pinctrl-apq8064 binding documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 4:30 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This adds a function ps_hold (Power Suppy Hold Signal) in pinctrl-ap8064
> documentation which was missing. This function is used to reset the targets
> with apq8064 soc.
>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> CC: Stephen Boyd <sboyd@codeaurora.org>
> CC: Andy Gross <agross@codeaurora.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Patch applied.

Yours,
Linus Walleij
