Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaH3FIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 01:08:51 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:52644 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbaH3FIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 01:08:50 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <54015C49.1020003@smartplayin.com>
Date: Sat, 30 Aug 2014 10:38:25 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [PATCH v3 4/4] pinctrl: qcom: Add support for reset for apq8064
References: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com> <1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com> <20140829184211.GI12494@sonymobile.com>
In-Reply-To: <20140829184211.GI12494@sonymobile.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,
Thanks for review. :)

On 30-08-2014 12:12 AM, Bjorn Andersson wrote:
> On Fri 29 Aug 07:30 PDT 2014, Pramod Gurav wrote:
> 
>> This patch adds support for reset functions to reboot the boards
>> with soc apq8064.
>>
>> CC: Linus Walleij <linus.walleij@linaro.org>
>> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>> CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>> CC: Stephen Boyd <sboyd@codeaurora.org>
>> CC: Andy Gross <agross@codeaurora.org>
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> 
> Thanks for the rework, that was fast :)
> 
> Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> 
