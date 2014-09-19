Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbaISMYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:24:42 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:34380 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbaISMYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:24:41 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <541C215F.5050009@smartplayin.com>
Date: Fri, 19 Sep 2014 17:58:15 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] pinctrl: qcom: use restart_notifier mechanism for ps_hold
References: <1411079579-10172-1-git-send-email-joshc@codeaurora.org>
In-Reply-To: <1411079579-10172-1-git-send-email-joshc@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

Tested this on IFC6410.
Tested-by: pramod.gurav@smartplayin.com

On Friday 19 September 2014 04:02 AM, Josh Cartwright wrote:
> By converting to the restart_notifier mechanism for restart, we allow
> for other mechanisms, like the watchdog, to be used for restart in the
> case where PS_HOLD has failed to reset the chip.
> 
> Choose priority 128, as according to documentation, this mechanism "is
> sufficient to restart the entire system".
> 
> Cc: Pramod Gurav <pramod.gurav@smartplayin.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---

