Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaCRInf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:43:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34661 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752560AbaCRInc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:43:32 -0400
Message-ID: <53280732.4060707@free-electrons.com>
Date: Tue, 18 Mar 2014 09:43:30 +0100
From: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/3] ARM: dts: berlin2q: add the Marvell Armada 1500
 pro
References: <1395068788-19786-1-git-send-email-antoine.tenart@free-electrons.com>	<1395068788-19786-2-git-send-email-antoine.tenart@free-electrons.com> <20140318102435.2d29abc7@xhacker>
In-Reply-To: <20140318102435.2d29abc7@xhacker>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng,

On 18/03/2014 03:24, Jisheng Zhang wrote:
>> +	sysclk: system-clock {
>> +		compatible = "fixed-factor-clock";
>> +		#clock-cells = <0>;
>> +		clocks = <&cpuclk>;
>> +		clock-multi = <1>;
>> +		clock-div = <3>;
>> +	};
>
> Can you please name it as twdclk to avoid confusion? On Berlin, sysclk is another
> clk rather than the clk for twd.

Sure, I'll change the name and send a v4.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
