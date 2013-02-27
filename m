Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684Ab3B0SRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:17:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48346 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759708Ab3B0SRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:17:02 -0500
Message-ID: <512E4D99.6030201@wwwdotorg.org>
Date: Wed, 27 Feb 2013 11:16:57 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "J, KEERTHY" <j-keerthy@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "liam.r.girdwood@intel.com" <liam.r.girdwood@intel.com>
Subject: Re: [PATCH 1/4] documentation: add palmas dts definition
References: <1361332815-2348-1-git-send-email-j-keerthy@ti.com> <20130220112639.GA2726@opensource.wolfsonmicro.com> <DC88CAD03C0052499C1907B327FC63229BBE34@DBDE01.ent.ti.com>
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229BBE34@DBDE01.ent.ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 06:49 AM, J, KEERTHY wrote:
> Mark Brown wrote at Wednesday, February 20, 2013 4:57 PM:
>> On Wed, Feb 20, 2013 at 09:30:15AM +0530, J Keerthy wrote:
>>> From: Graeme Gregory <gg@slimlogic.co.uk>
>>>
>>> Add the DTS definition for the palmas device including the MFD children.
...
>>> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
...
>>> +Texas Instruments Palmas family
>>> +
>>> +The Palmas familly are Integrated Power Management Chips.
>>> +These chips are connected to an i2c bus.
>>
>> I would expect this to enumerate the regulators that the user can
>> select but it doesn't appear to do that.
> 
> Mark,
> 
> Thanks for reviewing the patch.
> 
> I went through the DT Documentation files in the regulator/ folder.
> So shall I add a list of regulators which are in the Palmas device
> Under a separate file under Documentation/devicetree/bindings/regulator ?
> Is that what you are looking for?

I believe what Mark wants is something like the following in this file
(take from Documentation/devicetree/bindings/regulator/tps6586x.txt):

> - regulators: A node that houses a sub-node for each regulator within the
>   device. Each sub-node is identified using the node's name (or the deprecated
>   regulator-compatible property if present), with valid values listed below.
>   The content of each sub-node is defined by the standard binding for
>   regulators; see regulator.txt.
>   sys, sm[0-2], ldo[0-9] and ldo_rtc
