Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbaJNQRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:17:18 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58237 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbaJNQRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:17:17 -0400
Message-ID: <543D4C87.9050703@mm-sol.com>
Date: Tue, 14 Oct 2014 19:17:11 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v2 3/3] ARM: dts: qcom: Add SDHC nodes for APQ8084 platform
References: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>	<1409672443-4289-4-git-send-email-gdjakov@mm-sol.com> <CAJAp7OhV82HyDQSRW4F2z6UD6WZzuopBoUZMeT2pYBdGq-Dqcg@mail.gmail.com>
In-Reply-To: <CAJAp7OhV82HyDQSRW4F2z6UD6WZzuopBoUZMeT2pYBdGq-Dqcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 08:14 PM, Bjorn Andersson wrote:
> On Tue, Sep 2, 2014 at 8:40 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
>> Enable support for the two SD host controllers on the APQ8084 platform
>> by adding the required nodes to the DT files.
>> On the IFC6540 board, the first controller is connected to the onboard
>> eMMC and the second is connected to a micro-SD card slot.
>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> 
> Hi Georgi,
> 
> This looks sane, but...
> 
>> ---
>>  arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |   11 +++++++++++
>>  arch/arm/boot/dts/qcom-apq8084.dtsi        |   23 +++++++++++++++++++++++
>>  2 files changed, 34 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>> index e41cb8a..c9ff108 100644
>> --- a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>> +++ b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
> [..]
>> +               sdhci@f98a4900 {
>> +                       cd-gpios = <&tlmm 122 GPIO_ACTIVE_LOW>;
>> +                       bus-width = <4>;
> 
> ...why do you add this node and leave it disabled in the dts?
> 

Hi Bjorn,
Currently only the eMMC is functional on this board, so now we
have just the board specific configuration under this node.
More patches are forthcoming.

BR,
Georgi
