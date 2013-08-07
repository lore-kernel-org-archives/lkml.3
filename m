Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab3HGIIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:08:24 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:63922 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932282Ab3HGIIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:08:20 -0400
Message-ID: <52020066.3050500@atmel.com>
Date: Wed, 7 Aug 2013 16:08:06 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stephen Boyd <sboyd@codeaurora.org>, John Stultz <john.stultz@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] clock: correct the comparison parameter of MHz
References: <1375861660-32525-1-git-send-email-voice.shen@atmel.com> <20130807080253.GE23006@n2100.arm.linux.org.uk>
In-Reply-To: <20130807080253.GE23006@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell King,

On 8/7/2013 16:02, Russell King - ARM Linux wrote:
> On Wed, Aug 07, 2013 at 03:47:40PM +0800, Bo Shen wrote:
>> correct the comparison parameter of MHz from 4,000,000 to 1,000,000
>
> You're assuming this wasn't intentional.  As the division by 1000000
> ends up losing the fractional rate, I decided to leave 1-4MHz as kHz,
> so something like 1.832MHz would be displayed as 1832kHz and not
> 1MHz.

Thanks for clarification of this. Now, it is better for me to understand 
this piece of code.

Best Regards,
Bo Shen

