Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968144Ab3HIQfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:35:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54516 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968090Ab3HIQfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:35:54 -0400
Message-ID: <52051A66.1010001@wwwdotorg.org>
Date: Fri, 09 Aug 2013 10:35:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] Documentation: dt: hwmon: add OF document for
 lm90
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-4-git-send-email-wni@nvidia.com> <5203D757.8000208@wwwdotorg.org> <520487C7.5080901@nvidia.com>
In-Reply-To: <520487C7.5080901@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 12:10 AM, Wei Ni wrote:
> On 08/09/2013 01:37 AM, Stephen Warren wrote:
>> On 08/08/2013 12:56 AM, Wei Ni wrote:
>>> Add OF document for lm90 in Documentation/devicetree/.
>>
>>> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt b/Documentation/devicetree/bindings/hwmon/lm90.txt

>>> +- interrupts: lm90 can support interrupt mode, you can set interrupt here.
>>
>> You might want to mention that a single entry ("specifier") is expected
>> in the list.
> 
> Sorry, I didn't get your point, could you explain more?

In general, a device may have more than one interrupt output. Hence in
general, the interrupts property is a list of 1 or more interrupt
specifiers. In this case, that list should be a single entry. The
binding should state this. how about:

----------
Optional properties:
interrupts: Contains a single interrupt specifier which describes the
LM90 XXXX output. See interrupt-controller/interrupts.txt for the format.
----------

(where you'd replace XXXX with the pin/signal name from the datasheet).
