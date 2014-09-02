Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaIBMgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:36:15 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:53292 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaIBMgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:36:13 -0400
MIME-Version: 1.0
In-Reply-To: <1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com>
References: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>
	<1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 2 Sep 2014 14:36:12 +0200
Message-ID: <CACRpkdbnkgb2YOKAPTFSaDhj7OMbfF+14_PeDch5mFLwjOANEw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] pinctrl: qcom: Add support for reset for apq8064
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 4:30 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch adds support for reset functions to reboot the boards
> with soc apq8064.
>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> CC: Stephen Boyd <sboyd@codeaurora.org>
> CC: Andy Gross <agross@codeaurora.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

OK patch applied with Björn's ACK.

A bit dirty to have this in this driver, but who cares.

Does the APQ8064 accompanying PMIC also have the ability to
completely shut the system down?

Yours,
Linus Walleij
