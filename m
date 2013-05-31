Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3EaOaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:30:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43004 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3EaOaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:30:13 -0400
Message-ID: <51A8B3D6.1020608@ti.com>
Date: Fri, 31 May 2013 09:29:42 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7] ARM: dts: omap4-panda: Update the LED support for
 the panda DTS
References: <1369826427-31963-1-git-send-email-dmurphy@ti.com> <51A8AE72.5010601@ti.com>
In-Reply-To: <51A8AE72.5010601@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On 05/31/2013 09:06 AM, Benoit Cousson wrote:
> Hi Dan,
>
> On 05/29/2013 01:20 PM, Dan Murphy wrote:
>> The GPIO for LED D1 on the omap4-panda a1-a3 rev and the omap4-panda-es
>> are different.
>>
>> A1-A3 = gpio_wk7clean
>> ES = gpio_110
>>
>> There is no change to LED D2
>>
>> Abstract away the pinmux and the LED definitions for the two boards into
>> the respective DTS files.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> That patch was good... until Florian introduces some new constant to
> improve the readability of the DTS [1].
>
> Could you rebase on the lastest for_3.11/dts and use the macros for the
> GPIO and pinctrl nodes?
N/P working on it now

Thanks
> Thanks,
> Benoit
>
> [1] http://www.mail-archive.com/linux-omap@vger.kernel.org/msg89684.html
>

-- 
------------------
Dan Murphy

