Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3JNJVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:21:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38709 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab3JNJVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:21:04 -0400
Message-ID: <525BB74B.2040702@ti.com>
Date: Mon, 14 Oct 2013 12:20:11 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <bcousson@baylibre.com>
CC: <balbi@ti.com>, <pavel@ucw.cz>, <aaro.koskinen@iki.fi>,
        <marek@goldelico.com>, <tony@atomide.com>, <kishon@ti.com>,
        <bigeasy@linutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: dts: omap3:  Adapt USB OTG to generic PHY framework
References: <1381152493-28055-1-git-send-email-rogerq@ti.com> <1381152493-28055-2-git-send-email-rogerq@ti.com> <20131010153427.GI28375@radagast>
In-Reply-To: <20131010153427.GI28375@radagast>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On 10/10/2013 06:34 PM, Felipe Balbi wrote:
> On Mon, Oct 07, 2013 at 04:28:13PM +0300, Roger Quadros wrote:
>> The generic PHY framewrok expects different properties than the
>> old USB PHY framework. Supply those properties.
>>
>> Fixes USB OTG port on GAT04 and N900 after the Generic PHY framework was
>> merged in greg/usb-next. [1]
>>
>> [1] - https://lkml.org/lkml/2013/9/27/581
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Acked-by: Felipe Balbi <balbi@ti.com>
> 

Could you please pick this one for 3.13? Thanks.

I don't see it in your 3.13 take 2 pull request.

cheers,
-roger
