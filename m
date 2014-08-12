Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaHLUPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 16:15:40 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:47659 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaHLUPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 16:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140812181017.GA28666@amegan>
References: <1405917465-18185-1-git-send-email-apelete@seketeli.net>
	<1405917465-18185-3-git-send-email-apelete@seketeli.net>
	<CAPDyKFo4q+YWDgezZPqAHet0sBPE5WvnZzm00MHdf-+jZAY93Q@mail.gmail.com>
	<20140812181017.GA28666@amegan>
Date: Tue, 12 Aug 2014 22:15:35 +0200
Message-ID: <CAPDyKFrmq83pTCgUu2gR8spAYJPBgTx16JTQ++PKT7-zYjw6jQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] mmc: jz4740: prepare next dma transfer in parallel
 with current transfer
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Apelete Seketeli <apelete@seketeli.net>
Cc: Chris Ball <chris@printf.net>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alex Smith <alex.smith@imgtec.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2014 20:10, Apelete Seketeli <apelete@seketeli.net> wrote:
> On Tue, Aug-12-2014 at 06:22:04 PM +0200, Ulf Hansson wrote:
>> On 21 July 2014 06:37, Apelete Seketeli <apelete@seketeli.net> wrote:
>> > Make use of the MMC asynchronous request capability to prepare the
>> > next DMA transfer request in parallel with the current transfer.
>> > This is done by adding pre-request and post-request callbacks that are
>> > used by the MMC framework during an active data transfer.
>> >
>> > It should help reduce the impact of DMA preparation overhead on the SD
>> > card performance.
>> >
>> > Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
>>
>> Thanks! Queued for 3.18.
>
> W00t \o/ <-- hacker joy. Thank you :).
>
> Just out of curiosity, why not pulling these for 3.17 ?

I have had a vacation period. Since these are quite big changes, I
think they deserve some testing in linux-next and did not want to pull
in some late changes for 3.17.

Kind regards
Uffe

>
> Cheers.
> --
>         Apelete
