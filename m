Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3FQFy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:54:29 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:48849 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3FQFy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:54:26 -0400
MIME-Version: 1.0
In-Reply-To: <1370373600-31921-1-git-send-email-sboyd@codeaurora.org>
References: <1370373600-31921-1-git-send-email-sboyd@codeaurora.org>
Date: Mon, 17 Jun 2013 07:54:26 +0200
Message-ID: <CACRpkdZ5x3q9tn3J5_mQj-nJ_wO3HWgX5DTMQdMzF3mUDrAieQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: msm-v1: Remove errant __devinit to fix compile
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 9:20 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> Commit 7bce696 (gpio: Make gpio-msm-v1 into a platform driver,
> 2013-03-04) was based on an older kernel where __devinit still
> existed. Remove the erroneous __devinit marking.
>
> Cc: David Brown <davidb@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Patch applied.

Yours,
Linus Walleij
