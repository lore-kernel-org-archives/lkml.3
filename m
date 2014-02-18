Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaBROvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:51:48 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:43092 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbaBROvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:51:47 -0500
Message-ID: <53037373.4070701@elopez.com.ar>
Date: Tue, 18 Feb 2014 11:51:31 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/8] Add Allwinner A20 GMAC ethernet support
References: <1392028554-32545-1-git-send-email-wens@csie.org> <20140210194735.GY3192@lukather>
In-Reply-To: <20140210194735.GY3192@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 10/02/14 16:47, Maxime Ripard escribió:
> Hi Chen-Yu,
>
> On Mon, Feb 10, 2014 at 06:35:46PM +0800, Chen-Yu Tsai wrote:
>> Hi,
>>
>> This is the v4 of the remaining Allwinner A20 GMAC glue layer patches.
>> The stmmac driver changes have been merged through net-next. The
>> remaining bits are clock and DT patches. The patches should be applied
>> over my clock renaming patches.
>>
>> The Allwinner A20 SoC integrates an early version of dwmac
>> IP from Synopsys. On top of that is a hardware glue layer.
>> This layer needs to be configured before the dwmac can be
>> used.
>>
>> Part of the glue layer is a clock mux, which controls the
>> source and direction of the TX clock used by GMAC.
>
> Just merged patches 2-8.

And I just merged patch 1 on my branch for Mike

Cheers,

Emilio
