Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaBQOmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:42:50 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:39588 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaBQOmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:42:49 -0500
Message-ID: <53021FD9.2070406@elopez.com.ar>
Date: Mon, 17 Feb 2014 11:42:33 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140205183457.GW8533@titan.lakedaemon.net> <20140217141336.GA2765@localhost> <53021BD2.3090301@free-electrons.com>
In-Reply-To: <53021BD2.3090301@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory, Ezequiel,

 >> Are we still in time to consider Emilio's oneline proposal?
>> (Emilio: would you mind preparing a suitable patch against dove,
>> kirkwood, armada370/xp, so we can see the real thing?).

The patch is in a common file, so it does not need patching anything for 
each platform.

> I am still strongly against this proposal because hard-coded the parent
> clock name in the driver seems very wrong

It is hardcoded already when the parent is registered, so I do not 
understand your concern.

http://lxr.free-electrons.com/source/drivers/clk/mvebu/common.c?v=3.13#L34

> and moreover in some circumstances
> (if there is no output-name, which is our default case) this proposal
> just ignored the parent clock given by the device tree and this looked
> more wrong.

I have sent a second patch addressing this comment, but you do not seem 
to have taken too serious a look at it.

http://www.spinics.net/lists/arm-kernel/msg305922.html

Cheers,

Emilio
