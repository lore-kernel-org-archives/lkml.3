Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3EaVcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:32:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60551 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3EaVcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:32:00 -0400
Message-ID: <51A916CF.1070107@codeaurora.org>
Date: Fri, 31 May 2013 14:31:59 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv2 3/3] gpio: msm: Add device tree and irqdomain support
 for gpio-msm-v2
References: <1369268964-28304-1-git-send-email-rvaswani@codeaurora.org> <1369268964-28304-4-git-send-email-rvaswani@codeaurora.org> <20130531124256.D269C3E0901@localhost>
In-Reply-To: <20130531124256.D269C3E0901@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/2013 5:42 AM, Grant Likely wrote:
> On Wed, 22 May 2013 17:29:24 -0700, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
>> This cleans up the gpio-msm-v2 driver of all the global define usage.
>> The number of gpios are now defined in the device tree. This enables
>> adding irqdomain support as well.
>>
>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> Hi Rohit,
>
> Comments below on this driver...

Thanks Grant for your comments. Have addressed some of these in v3. Will 
fix the bitmap allocation and other comments in v4.

<snip>

Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

