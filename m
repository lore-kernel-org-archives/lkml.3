Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbaCEU7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:59:14 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38218 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaCEU7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:59:11 -0500
Message-ID: <5317901E.3020301@codeaurora.org>
Date: Wed, 05 Mar 2014 12:59:10 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] rtc: pm8xxx: use regmap API for register accesses
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org> <1394047776-13827-3-git-send-email-joshc@codeaurora.org>
In-Reply-To: <1394047776-13827-3-git-send-email-joshc@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/14 11:29, Josh Cartwright wrote:
> Now that the parent mfd driver has been made to work again, and has been
> reworked to create a regmap instance intended for it's children to use,
> rework the pm8xxx driver to use the regmap API for it's register
> accesses.
>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

