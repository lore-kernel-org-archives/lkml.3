Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaEWJKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:10:18 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38465 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaEWJKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:10:13 -0400
Message-ID: <537F1070.5010303@linaro.org>
Date: Fri, 23 May 2014 10:10:08 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 11/14] mmc: mmci: Add support to data commands via
 variant structure.
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400146660-30261-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdYZOpqyGJT4_Kf-TetiQoQrJwWbSrqUxDuRszutEM0HWw@mail.gmail.com>
In-Reply-To: <CACRpkdYZOpqyGJT4_Kf-TetiQoQrJwWbSrqUxDuRszutEM0HWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Linus W.

On 23/05/14 10:09, Linus Walleij wrote:
> On Thu, May 15, 2014 at 11:37 AM,  <srinivas.kandagatla@linaro.org> wrote:
>
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> On some SOCs like Qcom there are explicit bits in the command register
>> to specify if its a data transfer command or not. So this patch adds
>> support to such bits in variant data, giving more flexibility to the
>> driver.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij
>
