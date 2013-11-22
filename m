Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3KVVnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:43:39 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:44540 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3KVVng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:43:36 -0500
Message-ID: <528FD003.8090607@gmail.com>
Date: Fri, 22 Nov 2013 15:43:31 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH] dt-bindings: add ARMv8 PMU binding
References: <1385155032-9032-1-git-send-email-robherring2@gmail.com> <A8B9EAD7-0DBA-46D7-963F-30DEA0575EE2@codeaurora.org>
In-Reply-To: <A8B9EAD7-0DBA-46D7-963F-30DEA0575EE2@codeaurora.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 03:38 PM, Kumar Gala wrote:
> 
> On Nov 22, 2013, at 3:17 PM, Rob Herring <robherring2@gmail.com> wrote:
> 
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Add missing "arm,armv8-pmuv3" compatible property for ARMv8 PMU.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> ---
>> Documentation/devicetree/bindings/arm/pmu.txt | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/pmu.txt b/Documentation/devicetree/bindings/arm/pmu.txt
>> index 343781b..3e1e498 100644
>> --- a/Documentation/devicetree/bindings/arm/pmu.txt
>> +++ b/Documentation/devicetree/bindings/arm/pmu.txt
>> @@ -7,6 +7,7 @@ representation in the device tree should be done as under:-
>> Required properties:
>>
>> - compatible : should be one of
>> +	"arm,armv8-pmuv3”
> 
> what about arm,armv8-pmu-v3?

I'm just documenting what is already being used:

arch/arm64/boot/dts/foundation-v8.dts:          compatible =
"arm,armv8-pmuv3";
arch/arm64/boot/dts/rtsm_ve-aemv8a.dts:         compatible =
"arm,armv8-pmuv3";

Do we want to change those?

Rob

