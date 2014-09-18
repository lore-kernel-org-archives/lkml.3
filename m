Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbaIRWr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:47:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40783 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbaIRWrZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:47:25 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] pinctrl: qcom: use restart_notifier mechanism for ps_hold
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1411079579-10172-1-git-send-email-joshc@codeaurora.org>
Date: Thu, 18 Sep 2014 15:47:20 -0700
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guenter Roeck <linux@roeck-us.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <11F1E440-6BD4-46F1-A399-4334FBA2C3B6@codeaurora.org>
References: <1411079579-10172-1-git-send-email-joshc@codeaurora.org>
To: Josh Cartwright <joshc@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 18, 2014, at 3:32 PM, Josh Cartwright <joshc@codeaurora.org> wrote:

> By converting to the restart_notifier mechanism for restart, we allow
> for other mechanisms, like the watchdog, to be used for restart in the
> case where PS_HOLD has failed to reset the chip.
> 
> Choose priority 128, as according to documentation, this mechanism "is
> sufficient to restart the entire system”.

Will we use a higher priority for watchdog?  or how would we fail over to watchdog?

> 
> Cc: Pramod Gurav <pramod.gurav@smartplayin.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
> drivers/pinctrl/qcom/pinctrl-msm.c | 38 ++++++++++++++++++++++++++------------
> 1 file changed, 26 insertions(+), 12 deletions(-)
> 

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

