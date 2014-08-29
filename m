Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaH2Ac3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 20:32:29 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5148 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbaH2Ac2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 20:32:28 -0400
Date: Thu, 28 Aug 2014 17:32:26 -0700
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
Subject: Re: [PATCH 3/4] pinctrl: msm: Add ps_hold function in
 pinctrl-apq8064 binding documentation
Message-ID: <20140829003225.GD12494@sonymobile.com>
References: <1409282570-27299-1-git-send-email-pramod.gurav@smartplayin.com>
 <1409282570-27299-4-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409282570-27299-4-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28 Aug 20:22 PDT 2014, Pramod Gurav wrote:

> This adds a function ps_hold (Power Suppy Hold Signal) in pinctrl-ap8064
> documentation which was missing. This function is used to reset the targets
> with apq8064 soc.
> 
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Regards,
Bjorn
