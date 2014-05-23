Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaEWOSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:18:36 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:60104 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbaEWOSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:18:34 -0400
Message-ID: <537F58C0.6090006@mm-sol.com>
Date: Fri, 23 May 2014 17:18:40 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, sboyd@codeaurora.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1 3/5] clk: gcc: Add APQ8084 Global Clock Controller
 support
References: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com> <1400775885-10296-4-git-send-email-gdjakov@mm-sol.com> <DB9EC1F3-CA2B-47C5-A677-CC1222F05614@codeaurora.org>
In-Reply-To: <DB9EC1F3-CA2B-47C5-A677-CC1222F05614@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 07:38 PM, Kumar Gala wrote:
>
> On May 22, 2014, at 11:24 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
>
>> This patch adds support for the global clock controller found on
>> the APQ8084 based devices.
>>
>> The APQ8084 and MSM8974 share a lot of clock data, so instead of
>> duplicating all the data, we add support to the MSM8974 code.
>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
>> ---
>> drivers/clk/qcom/Kconfig                     |    4 +-
>> drivers/clk/qcom/gcc-msm8974.c               |  151 +++++++++++++++++++++++++-
>> include/dt-bindings/clock/qcom,gcc-msm8974.h |    4 +
>> 3 files changed, 154 insertions(+), 5 deletions(-)
>
> What about differences in reset?

Oops, will add this too. Thanks!

BR,
Georgi



