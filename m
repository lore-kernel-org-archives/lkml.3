Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaIQK4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:56:48 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:47898 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaIQK4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:56:46 -0400
Message-ID: <541968D8.2060609@ahsoftware.de>
Date: Wed, 17 Sep 2014 12:56:24 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Robin Gong <b38343@freescale.com>
CC: shawn.guo@freescale.com, kernel@pengutronix.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        fugang.duan@freescale.com
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on i.mx6dl
References: <1410327012-31185-1-git-send-email-b38343@freescale.com> <5416D26A.4080707@ahsoftware.de> <20140916035204.GB20800@Robin-OptiPlex-780> <541805E3.6080003@ahsoftware.de> <20140917085106.GB6369@Robin-OptiPlex-780>
In-Reply-To: <20140917085106.GB6369@Robin-OptiPlex-780>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.09.2014 10:51, schrieb Robin Gong:
> On Tue, Sep 16, 2014 at 11:41:55AM +0200, Alexander Holler wrote:
>> Am 16.09.2014 05:52, schrieb Robin Gong:
>>> On Mon, Sep 15, 2014 at 01:50:02PM +0200, Alexander Holler wrote:
>>>> Am 10.09.2014 07:30, schrieb Robin Gong:
>>>>> There is one weird data in rxfifo after one full rx/tx transfer
>>>>> done sometimes. It looks a design issue and hard to workaround
>>>>> totally, so disable dma functhion here. And will re-enable it
>>>>> once the root cause found.
>>>>
>>>> Hmm, I experience problems with DMA too but on uart3. I'm using the same
>>>> workaround for the uart (I've just commented out the dma entries in the DT).
>>>> The problem manifests itself here such, that brcm_patchram_plus
>>>> hangs while uploading the firmware to a BCM4330 connected at uart3
>>>> (reproducible).

(...)

> Yes, we just have fixed the BT issue over high speed UART last month. Suggest
> you trying our patches based on v3.10.

Thanks for the pointer. Will look if I will find these patches.

Regards,

Alexander Holler

