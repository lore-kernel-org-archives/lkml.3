Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaBFKgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:36:22 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:54933 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbaBFKgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:36:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140205005631.GA7664@verge.net.au>
References: <1391527445-14881-1-git-send-email-geert@linux-m68k.org>
	<20140205005631.GA7664@verge.net.au>
Date: Thu, 6 Feb 2014 19:36:17 +0900
Message-ID: <CANqRtoSrLV3PiUdbUQv9gTsM-p8tiqRvSza-=D9hG5fVn-CR0A@mail.gmail.com>
Subject: Re: [PATCH 00/11] ARM: shmobile: RSPI RZ and QSPI SoC and board integration
From: Magnus Damm <magnus.damm@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-spi@vger.kernel.org,
        SH-Linux <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 9:56 AM, Simon Horman <horms@verge.net.au> wrote:
> Magnus, could you Ack these or otherwise?
>
> On Tue, Feb 04, 2014 at 04:23:54PM +0100, Geert Uytterhoeven wrote:
>>       Hi Simon, Magnus,
>>
>> This patch series contains SoC and board integration for
>>   1. RSPI in the r7s72100 aka RZ/A1H SoC on the Genmai reference board,
>>   2. QSPI in the r8a7791 aka R-Car M2 SoC on the Koelsch reference board.
>> It was rebased on top of renesas-devel-v3.14-rc1-20140204.
>>
>> It was tested on the r7s72100-based Genmai reference board using loopback
>> mode, and on the r8a7791-based Koelsch reference board using the Spansion
>> s25fl512s SPI FLASH.
>>
>>   - [v5 01/11] ARM: shmobile: r7s72100 clock: Add RSPI clocks
>>   - [v5 02/11] ARM: shmobile: genmai legacy: Add RSPI support
>>   - [v3 03/11] ARM: shmobile: genmai defconfig: Enable RSPI
>>   - [v3 04/11] ARM: shmobile: r7s72100 clock: Add RSPI clocks for DT
>>   - [v5 05/11] ARM: shmobile: r7s72100 dtsi: Add RSPI nodes
>>   - [v4 06/11] ARM: shmobile: r8a7791 clock: add QSPI clocks
>>   - [v4 07/11] ARM: shmobile: koelsch legacy: Add QSPI support
>>   - [v4 08/11] ARM: shmobile: koelsch defconfig: Enable RSPI and
>>   - [v3 09/11] ARM: shmobile: r8a7791 dtsi: Add QSPI node
>>   - [v3 10/11] ARM: shmobile: koelsch dts: Add QSPI nodes
>>   - [v2 11/11] ARM: shmobile: lager legacy: Switch QSPI to named IRQs
>
> Above I see v2, v3, v4 and v5 patches.
>
> While I can make sense of this it makes it cumbersome to refer to the
> series as a whole.
>
> Bob, can you take a look at '"[PATCH 00/11] ARM: shmobile: RSPI RZ and
> QSPI SoC and board", posted on Tuesday the 2nd, which includes v2, v3,
> v4 and v5 patches'?
>
> What would make my life easier would be if the entire series was v5 and
> all the patches contained in it were v5. Then I could just ask Bob to look
> at "[PATCH v5 00/11] ARM: shmobile: RSPI RZ and QSPI SoC and board"
>
> There is no Bob but I do ask people these kind of questions :)

Simon, Geert, Bob,

I've now gone through these patches and I think they look great. My
apologies for slow handling.

Acked-by: Magnus Damm <damm@opensource.se>

Thanks for your help.

Cheers,

/ magnus
