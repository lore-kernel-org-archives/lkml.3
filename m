Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3JJJQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:16:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36061 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab3JJJQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:16:14 -0400
Message-ID: <5256703F.1070806@ti.com>
Date: Thu, 10 Oct 2013 12:15:43 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <bcousson@baylibre.com>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] Revert "ARM: OMAP2+: Provide alias to USB PHY
 clock"
References: <1381226799-29158-1-git-send-email-rogerq@ti.com> <1381226799-29158-6-git-send-email-rogerq@ti.com> <52550180.1000506@ti.com> <20131009151522.GA8313@atomide.com>
In-Reply-To: <20131009151522.GA8313@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 06:15 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [131009 00:19]:
>> Hi Tony,
>>
>> On 10/08/2013 01:06 PM, Roger Quadros wrote:
>>> This reverts commit 741532c4a995be11815cb72d4d7a48f442a22fea.
>>>
>>> The proper clock reference is provided in device tree so we
>>> no longer need this.
>>
>> Could you please Ack this one? I think it is best if it goes through Benoit's tree.
> 
> I could queue this into my board removal series that will be
> based on Benoit's branch if that works for you. And this
> also seems to depend on the omap-for-v3.13/quirk branch
> that moves all the legacy pdata handling into pdata-quirks.c.

OK Tony. Thanks.

cheers,
-roger
