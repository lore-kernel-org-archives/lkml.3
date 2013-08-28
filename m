Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3H1Bjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:39:48 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:48103 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752607Ab3H1Bjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:39:47 -0400
Message-ID: <521D54BE.5060100@atmel.com>
Date: Wed, 28 Aug 2013 09:39:10 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: mmotm 2013-08-27-16-51 uploaded
References: <20130827235227.99DB95A41D6@corp2gmr1-2.hot.corp.google.com> <521D494F.1010507@codeaurora.org>
In-Reply-To: <521D494F.1010507@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen Boyd,

On 08/28/2013 08:50 AM, Stephen Boyd wrote:
> On 08/27/13 16:52, akpm@linux-foundation.org wrote:
>> * kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch
>>
>
> I believe Russell nacked this change[1]? This should probably be dropped

Yes, this is RFC patch, and NACKed by Russell, so we can drop it.

> unless there's been more discussion. Or maybe reworked into a comment in
> the code that doesn't lead to the same change again.
>
> [1] https://lkml.org/lkml/2013/8/7/95
>

Best Regards,
Bo Shen
