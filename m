Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab3DQTrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:47:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60452 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab3DQTrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:47:05 -0400
Message-ID: <516EFC32.6030005@ti.com>
Date: Wed, 17 Apr 2013 14:46:58 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: omap4-panda: Add LED support into the panda
 DTS files
References: <1366225778-6083-1-git-send-email-dmurphy@ti.com> <1366225778-6083-2-git-send-email-dmurphy@ti.com> <516EF59E.3090907@ti.com>
In-Reply-To: <516EF59E.3090907@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 02:18 PM, Jon Hunter wrote:
> On 04/17/2013 02:09 PM, Dan Murphy wrote:
>> The GPIO for LED D1 on the omap4-panda a1-a3 rev and the omap4-panda-es
>> are different.
>>
>> Abstract away the pinmux and the LED definitions for the two boards.
> Just a heads-up but you should base this upon Benoit's for_3.10 branch
> [1] as there is now a omap4-panda-common.dtsi where the led stuff
> currently resides.
>
> Cheers
> Jon
>
> [1]
> http://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.10/dts
Thanks Jon.  Will resend against Benoit's tree.

Dan

-- 
----------------------------------------------
Dan Murphy

