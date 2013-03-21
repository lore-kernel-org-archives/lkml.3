Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3CURau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:30:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50933 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3CURas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:30:48 -0400
Message-ID: <514B43C5.6060404@wwwdotorg.org>
Date: Thu, 21 Mar 2013 11:30:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, swarren@nvidia.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/4] ARM: tegra: dalmore: add cpu regulator node
References: <1363873663-19272-1-git-send-email-ldewangan@nvidia.com> <1363873663-19272-2-git-send-email-ldewangan@nvidia.com> <514B1412.9060707@cogentembedded.com>
In-Reply-To: <514B1412.9060707@cogentembedded.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 08:07 AM, Sergei Shtylyov wrote:
> Hello.
> 
> On 21-03-2013 17:47, Laxman Dewangan wrote:
> 
>> Dalmore uses the TPS51632 as CPU regulator. The device is connected
>> on I2C5.
> 
>> Add DT node for TPS51632.

>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts

>> +    i2c@7000d000 {
>> +        status = "okay";
>> +        clock-frequency = <400000>;
>> +
>> +        tps51632 {
> 
>    Should be named "tps51632@43" I think.

The unit-address (i.e. "@43" part) of the node name is typically omitted
if it isn't required to make the node name unique.
