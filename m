Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbaEMJgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:36:47 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:34641 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883AbaEMJgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:36:42 -0400
Message-ID: <5371E79B.2010402@linaro.org>
Date: Tue, 13 May 2014 10:36:27 +0100
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
Subject: Re: [PATCH v1 08/11] mmc: mmci: Qcom fix MCICLK register settings.
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>	<1398759638-13299-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdYyFWAYsPT1jvOLCpx9dOTL9P-J=45BNqEi5TZ4Zd3vVw@mail.gmail.com>
In-Reply-To: <CACRpkdYyFWAYsPT1jvOLCpx9dOTL9P-J=45BNqEi5TZ4Zd3vVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Linus W.

On 13/05/14 09:19, Linus Walleij wrote:
> Again follow the pattern of storing register templates in the vendor_data
> struct. I think you will quickly realize how this can be cut down with
> new fields like .clk_4bitmode etc.
>
>> >  /* Modified PL180 on Versatile Express platform */
>> >  #define MCI_ARM_HWFCEN         (1 << 12)
>> >
>> >+/* Modified on Qualcomm Integrations */
> First: follow the convention set for the ST-specific registers that
> look e.g. like this:
I agree, Will fix these in next version.
>
> MCI_ST_8BIT_BUS i.e. MCI_<vendor>_SPECIFIER
> So the below becomes MCI_QCOM_CLK_WIDEBUS... etc.
>
