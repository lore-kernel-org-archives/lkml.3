Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbaEMJDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:03:12 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:58993 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071AbaEMJDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:03:07 -0400
Message-ID: <5371DFC0.7030801@linaro.org>
Date: Tue, 13 May 2014 10:02:56 +0100
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
Subject: Re: [PATCH v1 05/11] mmc: mmci: use NSEC_PER_SEC macro
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>	<1398759601-13178-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdYB+6PeY6HMYe1t2VBPrv1sUtZkEimNPPHor9ziaUAztg@mail.gmail.com>
In-Reply-To: <CACRpkdYB+6PeY6HMYe1t2VBPrv1sUtZkEimNPPHor9ziaUAztg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13/05/14 08:20, Linus Walleij wrote:
> On Tue, Apr 29, 2014 at 10:20 AM,  <srinivas.kandagatla@linaro.org> wrote:
>
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> This patch replaces a constant used in calculating timeout with a proper
>> macro. This is make code more readable.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>
> This can be merged out-of-order just as-is.
Agreed, I can take this patch out of this series.

thanks,
srini
>
> Yours,
> Linus Walleij
>
