Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbbAMMRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:17:37 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:41008 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbAMMRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:17:35 -0500
Message-ID: <54B50CDA.3090307@gmail.com>
Date: Tue, 13 Jan 2015 13:17:30 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Mike Turquette <mturquette@linaro.org>,
        Jisheng Zhang <jszhang@marvell.com>
CC: "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "antoine.tenart@free-electrons.com" 
	<antoine.tenart@free-electrons.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 3/3] clk: berlin: bg2q: remove non-exist "smemc" gate
 clock
References: <1420016272-6789-1-git-send-email-jszhang@marvell.com> <1420016272-6789-4-git-send-email-jszhang@marvell.com> <54AD3EAE.6090009@gmail.com> <20150107222209.64ed24a0@xhacker> <54AD431F.6060403@gmail.com> <20150109201306.4d1a296b@xhacker> <54B12446.4030703@gmail.com> <20150113002817.20842.98432@quantum>
In-Reply-To: <20150113002817.20842.98432@quantum>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 01:28 AM, Mike Turquette wrote:
> Quoting Sebastian Hesselbarth (2015-01-10 05:08:22)
>> This is clk subsystem, so either Mike takes it through his fixes branch
>> including my
>>
>> Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>
>> or decides to agree that I take it instead with his Ack. I am fine
>> with both.
>
> Acked-by: Michael Turquette <mturquette@linaro.org>
>
> Now the three fixes can stay together and live happily ever after.

Mike,

I already had the two others pulled by Olof some days ago.
If you plan for a fixes branch for v3.19, please take this in too.

If you have no other fixes, I can take it and do a 2nd round of
fixes for Berlin.

Sebastian

