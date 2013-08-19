Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750845Ab3HSFG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 01:06:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34250 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3HSFG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 01:06:56 -0400
Message-ID: <5211A7B3.4040906@ti.com>
Date: Mon, 19 Aug 2013 10:35:55 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, <cw00.choi@samsung.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ian.campbell@citrix.com>, <rob@landley.net>,
        <george.cherian@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-doc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH v2] extcon: palmas: Modified the compatible type to *ti,palmas-usb-vid*
References: <1376648448-27447-1-git-send-email-kishon@ti.com> <520EA5D6.3040409@wwwdotorg.org>
In-Reply-To: <520EA5D6.3040409@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 17 August 2013 03:51 AM, Stephen Warren wrote:
> On 08/16/2013 04:20 AM, Kishon Vijay Abraham I wrote:
>> The Palmas device contains only a USB VID detector, so modified the
>> compatible type to *ti,palmas-usb-vid*.
> 
>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
> 
>>  PALMAS USB COMPARATOR
>>  Required Properties:
>> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
>> + - compatible : Should be "ti,palmas-usb-vid".
> 
> Has the old value been published in a release kernel? If so, it makes

No. This was merged only in 3.11-rc1. So I think we should take this version?
Chanwoo can you take this patch?

Thanks
Kishon
