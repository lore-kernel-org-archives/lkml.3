Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbaEMJAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:00:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62283 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029AbaEMJAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:00:42 -0400
Message-ID: <5371DF37.9060409@linaro.org>
Date: Tue, 13 May 2014 10:00:39 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v1 02/11] mmc: mmci: Add Qualcomm Id to amba id table
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>	<1398759556-13056-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdZr1MP2CL-609iJnv=MRHDhK554Hui5U77_SSUf7ARUqg@mail.gmail.com>
In-Reply-To: <CACRpkdZr1MP2CL-609iJnv=MRHDhK554Hui5U77_SSUf7ARUqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Linus W.

On 13/05/14 08:17, Linus Walleij wrote:
> On Tue, Apr 29, 2014 at 10:19 AM,  <srinivas.kandagatla@linaro.org> wrote:
>
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> This patch adds a fake Qualcomm ID 0x00051180 to the amba_ids, as Qualcomm
>> SDCC controller is pl180, but amba id registers read 0x0's.
>> The plan is to remove SDCC driver totally and use mmci as the main SD
>> controller driver for Qualcomm SOCs.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>
