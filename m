Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3GYQge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:36:34 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4538 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab3GYQgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:36:16 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51F153F2.4080107@broadcom.com>
Date: Thu, 25 Jul 2013 18:36:02 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Tim Kryger" <tim.kryger@linaro.org>
cc: "Christian Daudt" <csd@broadcom.com>, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Lee Jones" <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/22] ARM: dts: bcm281xx: Remove '0x's from
 BCM11351 BRT DTS file
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-5-git-send-email-lee.jones@linaro.org>
 <51ED2D90.4020209@broadcom.com> <20130722133852.GA26801@laptop>
 <51ED3971.905@broadcom.com> <51ED6486.3080700@broadcom.com>
 <CAAYSxhrf+WNz1+ojA1r_pOLWg4xf9Ko8OyUc4GfVEMUN776pfA@mail.gmail.com>
In-Reply-To: <CAAYSxhrf+WNz1+ojA1r_pOLWg4xf9Ko8OyUc4GfVEMUN776pfA@mail.gmail.com>
X-WSS-ID: 7DEF8E242L852111417-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 05:43 PM, Tim Kryger wrote:
> On Mon, Jul 22, 2013 at 9:57 AM, Christian Daudt <csd@broadcom.com> wrote:
>
>> it'd be nice to have something to point
>> people to as this being the best practice for kernel dev.
>
> Power.org's ePAPR exclusively omits the 0x in the unit-address of node names.
>
> https://www.power.org/wp-content/uploads/2012/06/Power_ePAPR_APPROVED_v1.1.pdf
>

Thanks for the link. While browsing on power.org I got the impression 
that I needed to have a membership to get it.

Regards,
Arend

