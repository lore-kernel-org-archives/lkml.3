Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbbA0KSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:18:11 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39555 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589AbbA0KSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:18:04 -0500
MIME-Version: 1.0
In-Reply-To: <20150127001419.GO21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com> <20150127001419.GO21293@sirena.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 27 Jan 2015 11:17:42 +0100
Message-ID: <CAPybu_1==6gvwbWQWxSj_C3siGFTjvqNh1=Xj6jvu_xQFOA-Kw@mail.gmail.com>
Subject: Re: [PATCH 00/18] spi/xilinx: Speed-up
To: Mark Brown <broonie@kernel.org>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark

On Tue, Jan 27, 2015 at 1:14 AM, Mark Brown <broonie@kernel.org> wrote:

>
> In general the best way to present a series is to start off with any bug
> fixes (so they can be sent to Linus and stable if needed), then move on
> to mechanical and stylistic cleanups (since they tend to be easy to
> review and apply) and finally move on to new functionality (since that
> is most likely to run into review problems and the cleanups should help
> review).

Will try to follow that pattern the next time.

The development of the patchset has been a bit chaotic. I opened up
the code to support more modes and then I realize that I could improve
the poor performance I was having with the driver....

>
>>   spi/xilinx: Support for spi mode LOOP
>>   spi/xilinx: Simplify data read from the Rx FIFO
>>   spi-xilinx: Simplify spi_fill_tx_fifo
>
> spi-xilinx?

Thanks! Fixed on the next version.

BTW what is preferred spi/xilinx: or spi: xilinx: ?I have seen both naming.

Thanks!


-- 
Ricardo Ribalda
