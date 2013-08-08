Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966510Ab3HHUk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:40:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32795 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966356Ab3HHUk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:40:26 -0400
Message-ID: <52040236.2080701@wwwdotorg.org>
Date: Thu, 08 Aug 2013 14:40:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        MLongnecker@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/3] ARM: dt: t114 dalmore: add dt entry for nct1008
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-3-git-send-email-wni@nvidia.com> <52040146.7060703@cogentembedded.com>
In-Reply-To: <52040146.7060703@cogentembedded.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 02:36 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 08/08/2013 10:56 AM, Wei Ni wrote:
> 
>> Enable thermal sensor nct1008 for t114 dalmore.
> 
>> Signed-off-by: Wei Ni <wni@nvidia.com>
>> ---
>>   arch/arm/boot/dts/tegra114-dalmore.dts |   10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts
>> b/arch/arm/boot/dts/tegra114-dalmore.dts
>> index b5a42f0..9d4d2b2 100644
>> --- a/arch/arm/boot/dts/tegra114-dalmore.dts
>> +++ b/arch/arm/boot/dts/tegra114-dalmore.dts
>> @@ -738,6 +738,14 @@
>>               realtek,ldo1-en-gpios =
>>                   <&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
>>           };
>> +
>> +        nct1008 {
> 
>    ePAPR [1] says: "the name of a node should be somewhat generic,
> reflecting the function of the device and not its precise programming
> model". So I suggest "thermal"

True, although there's quite some precedent for node-names being the
chip name for external chips in existing DTs. If we change this node
name, I'd like to see a patch that makes all the other "nct1008" nodes
match the new name...

