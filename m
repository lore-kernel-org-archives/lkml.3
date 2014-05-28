Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaE1IwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:52:07 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:53333 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaE1IwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:52:04 -0400
Message-ID: <5385A3AF.7060302@linaro.org>
Date: Wed, 28 May 2014 09:51:59 +0100
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
Subject: Re: [PATCH v3 13/13] mmc: mmci: Add Qcom specific pio_read function.
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400849589-7626-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdb+pUn=9UkEVhK_2nL8C2wq_6qOuuRV52TRnj1hJiHvSg@mail.gmail.com>
In-Reply-To: <CACRpkdb+pUn=9UkEVhK_2nL8C2wq_6qOuuRV52TRnj1hJiHvSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 28/05/14 09:08, Linus Walleij wrote:
> On Fri, May 23, 2014 at 2:53 PM,  <srinivas.kandagatla@linaro.org> wrote:
>
>> +       if (unlikely(bytes)) {
>> +               unsigned char buf[4];
> (...)

>
> Please think twice about this.
> http://lwn.net/Articles/70473/
> http://lwn.net/Articles/420019/
> http://lwn.net/Articles/182369/
>
Thanks for the warning.

You are right. I think having likely/unlikely is not always right here.

thanks,
srini
> Yours,
> Linus Walleij
>
