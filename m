Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaHUM2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:28:49 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:37886 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaHUM2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <1408057161-6940-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1408057161-6940-1-git-send-email-bjorn.andersson@sonymobile.com>
Date: Thu, 21 Aug 2014 07:28:46 -0500
Message-ID: <CACRpkdYqKtq9OASPeiS447jJ7ZnCCcUhwYLJWnvTqsjvxP07Rw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: qcom: apq8064: Correct interrupts in example
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Kiran Padwal <kiran.padwal@smartplayin.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 5:59 PM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:

> The example in the binding document indicates that interrupt 32 is used
> for the TLMM summary IRQ. Correct this to reduce the confusion.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Patch applied.

Yours,
Linus Walleij
