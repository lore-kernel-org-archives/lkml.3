Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaB0QAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:00:13 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:57704 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaB0QAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:00:11 -0500
MIME-Version: 1.0
In-Reply-To: <1393441943-1689-1-git-send-email-sboyd@codeaurora.org>
References: <1393441943-1689-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 27 Feb 2014 08:00:10 -0800
Message-ID: <CAJAp7Ojmx8FVR_JgWkyw7xKDBq55gT1-cmkveFSPVXB2Q8VYxA@mail.gmail.com>
Subject: Re: [PATCH] devicetree: bindings: Make msm8974-pinctrl documentation
 match code
From: Bjorn Andersson <bjorn@kryo.se>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 11:12 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> The compatible string doesn't have an x in it. Fix it. Also
> remove the "qcom" prefix from pins and functions as this binding
> uses the generic pinctrl bindings for the pins and functions.
>
> Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks Stephen, this looks good. Sorry for missing this before.

Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
