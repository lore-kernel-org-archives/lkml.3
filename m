Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaJ1UGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:06:37 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24017 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaJ1UGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:06:35 -0400
X-IronPort-AV: E=Sophos;i="5.04,804,1406617200"; 
   d="scan'208";a="49188369"
Message-ID: <544FF744.5020707@broadcom.com>
Date: Tue, 28 Oct 2014 13:06:28 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v8 8/8] ARM: multi_v7_defconfig: Enable Broadcom Cygnus
References: <1414525992-3678-9-git-send-email-sbranden@broadcom.com> <5089697.D8odgNlVtY@wuerfel>
In-Reply-To: <5089697.D8odgNlVtY@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-28 01:01 PM, Arnd Bergmann wrote:
> On Tuesday 28 October 2014 12:53:12 Scott Branden wrote:
>> From: Ray Jui <rjui@broadcom.com>
>>
>> Enable Broadcom Cygnus platform support in multi_v7_defconfig
>>
>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>>
>
> Just to be sure: did you check that multi_v7_defconfig contains
> all the drivers you need that you enable in your other defconfig?
No - the other defconfig has more that have not been tested on the 
device.  The defconfig builds, but the other drivers haven't been 
tested.  I guess we can try adding them to the multi_defconfig right now 
as well or wait until we have tested them?  There will need to be 
addition dts changes in the future after we have tested the other drivers.

Can we wait to add them to multi_v7_defconfig or do you want them in 
this patchset?
>
> 	Arnd
>

