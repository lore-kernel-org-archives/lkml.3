Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaIDVWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:22:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57149 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaIDVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:22:39 -0400
Message-ID: <5408D81C.7070602@codeaurora.org>
Date: Thu, 04 Sep 2014 14:22:36 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>
Subject: Re: [PATCH] mmc: sdhci-msm: Make tuning block table endian agnostic
References: <1409752622-7564-1-git-send-email-sboyd@codeaurora.org>	<5407F364.9030303@samsung.com> <CAPDyKFp0LwK=DABHaP-Ke=QZFP8bY5MO9RnYmUBqeEdDKp63BA@mail.gmail.com>
In-Reply-To: <CAPDyKFp0LwK=DABHaP-Ke=QZFP8bY5MO9RnYmUBqeEdDKp63BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 03:53, Ulf Hansson wrote:
> On 4 September 2014 07:06, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>
>> In dw-mmc.c, tuning_block values are same.
>> So I think we can move these value into generic header. how about?
> Actually, I believe these values comes from the eMMC specification?
> Shouldn't they be moved to the mmc core instead?

That sounds like good consolidation, but can we do that in a follow-up
patch? This fixes the driver for me and I was hoping to make something
minimal to go back to stable trees.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

