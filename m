Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaGGOVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:21:46 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52705 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaGGOVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:21:45 -0400
MIME-Version: 1.0
In-Reply-To: <1403066951-31266-1-git-send-email-agross@codeaurora.org>
References: <1403066951-31266-1-git-send-email-agross@codeaurora.org>
Date: Mon, 7 Jul 2014 16:21:44 +0200
Message-ID: <CACRpkdYh4fAM1xwa7Z-=NoAc9VWTUR=NgyyJUurpbwsnv+Zfjw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: qcom: Add BUS_HOLD pin bias
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Gross <agross@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 6:49 AM, Andy Gross <agross@codeaurora.org> wrote:

> This patch adds the BUS_HOLD (Keeper) bias option for pins.
>
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Patch applied with Björn's ACK, thanks Andy.

Yours,
Linus Walleij
