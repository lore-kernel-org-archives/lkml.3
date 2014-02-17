Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaBQM6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 07:58:51 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:49739 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070AbaBQM6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 07:58:50 -0500
Message-ID: <53020743.1070509@st.com>
Date: Mon, 17 Feb 2014 13:57:39 +0100
From: Fabrice Gasnier <fabrice.gasnier@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fabrice GASNIER <fabrice.gasnier@stericsson.com>
Cc: <u.kleine-koenig@pengutronix.de>, <jonathan.austin@arm.com>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>, <nico@linaro.org>,
        <sboyd@codeaurora.org>, <marc.zyngier@arm.com>,
        <ben.dooks@codethink.co.uk>, <vgupta@synopsys.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>
Subject: Re: [PATCH v2] ARM: Add imprecise abort enable/disable macro
References: <1392050756-11145-1-git-send-email-fabrice.gasnier@st.com> <52FB71A3.5010505@stericsson.com> <20140212131834.GP26684@n2100.arm.linux.org.uk>
In-Reply-To: <20140212131834.GP26684@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/12/2014 02:18 PM, Russell King - ARM Linux wrote:
> On Wed, Feb 12, 2014 at 02:05:39PM +0100, Fabrice GASNIER wrote:
>> Hi,
>>
>> Any comments on this patch ?
>>
>> Russell, can I add this patch to your patch tracker system ?
> I don't see how this works on anything but ARMv7M.
>
Hi Russel,

I'm not sure how I can help to do that part for ARMv7M.
Point is I don't have any ARMv7M hardware at my disposal to develop 
and/or test with.

Hopefully someone can help or take care of this part ?

BR,
Fabrice
