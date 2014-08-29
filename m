Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaH2SmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:42:16 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19240 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759AbaH2SmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:42:14 -0400
Date: Fri, 29 Aug 2014 11:42:13 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [PATCH v3 4/4] pinctrl: qcom: Add support for reset for apq8064
Message-ID: <20140829184211.GI12494@sonymobile.com>
References: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>
 <1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 29 Aug 07:30 PDT 2014, Pramod Gurav wrote:

> This patch adds support for reset functions to reboot the boards
> with soc apq8064.
> 
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> CC: Stephen Boyd <sboyd@codeaurora.org>
> CC: Andy Gross <agross@codeaurora.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Thanks for the rework, that was fast :)

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

