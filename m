Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaHFMTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:19:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47653 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaHFMTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:19:34 -0400
Message-ID: <53E21D53.30606@codeaurora.org>
Date: Wed, 06 Aug 2014 08:19:31 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH] i2c: qup: disable clks and return instead of just returning
 error
References: <1407311602-15751-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1407311602-15751-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pramod,

Not a big deal, but some typos caught my eye.

On 08/06/2014 03:53 AM, Pramod Gurav wrote:
> This fixes a error handling scenario where clocks were not being disabled
> when QUP_OUTPUT_BLOCK_SIZE returns a size greater thanat size of blk_sizes

s/thanat/than the/

> array. So this patch adds a statement to jump to err lable to release the

s/err lable/the error label/ or s/err lable/the fail label/

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
