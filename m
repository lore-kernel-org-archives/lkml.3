Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab3HFRBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:01:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38635 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3HFRBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:01:23 -0400
Message-ID: <52012BDF.70401@wwwdotorg.org>
Date: Tue, 06 Aug 2013 11:01:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 2/2] pinctrl: add generic pins and functions properties
References: <1375739760-18833-1-git-send-email-swarren@wwwdotorg.org> <1375739760-18833-2-git-send-email-swarren@wwwdotorg.org> <20130806084131.GB23111@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130806084131.GB23111@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 02:41 AM, Mark Rutland wrote:
> On Mon, Aug 05, 2013 at 10:56:00PM +0100, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> pinctrl bindings can benefit from generic property names that define
>> which pins a "pin configuration node" affects, and which mux function
>> to select onto those pins. Document new properties for this purpose so
>> that other bindings may refer to them.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>>  Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
>> index 31b0cb9..237823a 100644
>> --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
>> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
>> @@ -138,6 +138,9 @@ structure of the DT nodes that contain these properties.
>>  
>>  Supported generic properties are:
>>  
>> +pins			- the list of pins that properties in the node
>> +			  apply to
>> +function		- the mux function to select
> 
> I assume the type of these properties must be described in the more
> specific binding?

Yes, I think so. I guess I should also add entries into the section
right below this list which describes the values for each of the
properties that has values.
