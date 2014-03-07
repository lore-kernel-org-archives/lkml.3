Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaCGB2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:28:43 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:57315 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaCGB2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:28:41 -0500
MIME-Version: 1.0
In-Reply-To: <1393441943-1689-1-git-send-email-sboyd@codeaurora.org>
References: <1393441943-1689-1-git-send-email-sboyd@codeaurora.org>
Date: Fri, 7 Mar 2014 09:28:40 +0800
Message-ID: <CACRpkdbrW2YgSpXS4s3MsZbnxS+sT6VYQ6t0i_bSiVom2bdKCg@mail.gmail.com>
Subject: Re: [PATCH] devicetree: bindings: Make msm8974-pinctrl documentation
 match code
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 3:12 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> The compatible string doesn't have an x in it. Fix it. Also
> remove the "qcom" prefix from pins and functions as this binding
> uses the generic pinctrl bindings for the pins and functions.
>
> Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks Stephen, patch applied with Björn's ACK.

Yours,
Linus Walleij
