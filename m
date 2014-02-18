Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaBRSpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:45:35 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37824 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaBRSpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:45:32 -0500
Message-ID: <5303A9F6.4030904@codeaurora.org>
Date: Tue, 18 Feb 2014 10:44:06 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 7/7] devicetree: bindings: Document PM8921/8058 PMICs
References: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org> <1389206270-3728-8-git-send-email-sboyd@codeaurora.org> <20140211092937.GG32042@lee--X1> <20140213053813.GB14769@codeaurora.org> <20140213110619.GI32508@lee--X1>
In-Reply-To: <20140213110619.GI32508@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/14 03:06, Lee Jones wrote:
>> These match the #defines in that file. I'd like to be explicit
>> about the numbers to prevent people from thinking they have to
>> use #defines and to match what other irq controllers have done
>> (gic, atmel-aic, etc.)
> I believe people _do_ have to use the #defines? Is there a good reason
> for you not wanting to use them?
>

No, there isn't any requirement to use #defines in DT.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

