Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaIWRnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:43:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42260 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbaIWRm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:42:58 -0400
Message-ID: <5421B120.10106@codeaurora.org>
Date: Tue, 23 Sep 2014 10:42:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Josh Cartwright <joshc@codeaurora.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v3] power: reset: use restart_notifier mechanism for msm-poweroff
References: <1411452520-29589-1-git-send-email-pramod.gurav@smartplayin.com> <542112FD.7080302@smartplayin.com>
In-Reply-To: <542112FD.7080302@smartplayin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/14 23:28, Pramod Gurav wrote:
> +linux-arm-msm
> On Tuesday 23 September 2014 11:38 AM, Pramod Gurav wrote:
>> This change replaces use of arm_pm_restart with recently introduced
>> reset mechanism in Linux kernel called restart_notifier.
>>
>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>> Cc: Guenter Roeck <linux@roeck-us.net>
>> Cc: Josh Cartwright <joshc@codeaurora.org>
>> Cc: Sebastian Reichel <sre@kernel.org>
>> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Stephen Boyd <sboyd@codeaurora.org>
>> Cc: linux-pm@vger.kernel.org
>>
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>> ---

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

