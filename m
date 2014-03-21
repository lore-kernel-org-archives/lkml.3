Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaCUWfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 18:35:46 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55134 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaCUWfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 18:35:42 -0400
Message-ID: <532CBEB9.70902@gmail.com>
Date: Fri, 21 Mar 2014 23:35:37 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>, Jimmy Xu <zmxu@marvell.com>,
        Jisheng Zhang <jszhang@marvell.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 1/5] clk: berlin: add support for berlin plls
References: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com> <1395432521-11055-2-git-send-email-alexandre.belloni@free-electrons.com> <532CAD99.4060307@gmail.com> <20140321222243.GK6443@piout.net>
In-Reply-To: <20140321222243.GK6443@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 11:22 PM, Alexandre Belloni wrote:
> On 21/03/2014 at 22:22:33 +0100, Sebastian Hesselbarth wrote :
>> On 03/21/2014 09:08 PM, Alexandre Belloni wrote:
>>> This drivers allows to provide DT clocks for the cpu and system PLLs found on
>>> Marvell Berlin SoCs.
>>
>> Alexandre,
>>
>> as mentioned on IRC, I now had a closer look on it. Some minor
>> remarks below. Sorry, I didn't mention them earlier.
>
> To clarify things, I'll just resend patch 1 and you are ready to take
> 2-5, fixing up the remaining comments as soon as Mike takes it ?

Yes, no need to resend 2-5. Just keep on incrementing version on 1/5.
If you send a v3 for patch 1, I can also prepare a topic branch that
we refer to until Mike either takes the single patch or pulls the topic
branch.

I'll work it out with Mike, but for a single patch, I guess he'll
take it through his tree.

As we target this all for v3.16, I'll get back to this, as soon as I
have proper branches on v3.15-rc1 and possibly also managed it to have
a for-next branch that gets pulled into linux-next.

Sebastian

