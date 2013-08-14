Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3HNFZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 01:25:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37384 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3HNFZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 01:25:38 -0400
Message-ID: <520B14A1.8030809@ti.com>
Date: Wed, 14 Aug 2013 10:54:49 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <benoit.cousson@linaro.org>, <tony@atomide.com>,
        <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ian.campbell@citrix.com>, <rob@landley.net>,
        <george.cherian@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-doc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH 1/2] extcon: palmas: Added a new compatible type *ti,palmas-usb-vid*
References: <1376302675-15795-1-git-send-email-kishon@ti.com> <1376372241-15573-1-git-send-email-kishon@ti.com> <520A8555.10401@wwwdotorg.org>
In-Reply-To: <520A8555.10401@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 14 August 2013 12:43 AM, Stephen Warren wrote:
> On 08/12/2013 11:37 PM, Kishon Vijay Abraham I wrote:
>> The Palmas device contains only a USB VID detector, so added a
>> compatible type *ti,palmas-usb-vid*. Dint remove the existing compatible
> 
> s/Dint/Didn't/
> 
>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-twl.txt b/Documentation/devicetree/bindings/extcon/extcon-twl.txt
> 
>>  PALMAS USB COMPARATOR
>>  Required Properties:
>> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
>> + - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb" or
>> +   "ti,palmas-usb-vid".
> 
> So are ti,palmas-usb and ti,twl6035-usb full EHCI controllers then?

No. I thought I shouldn't remove those if someone is already using those
compatible value.

Thanks
Kishon

