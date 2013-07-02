Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3GBINb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:13:31 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:57259 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab3GBIN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:13:29 -0400
MIME-Version: 1.0
In-Reply-To: <51D24299.9050209@atmel.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
 <1372667978-4718-2-git-send-email-richard.genoud@gmail.com> <51D24299.9050209@atmel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 2 Jul 2013 10:13:08 +0200
Message-ID: <CACQ1gAgcc=j3kmcpjp8bbdHhxr_k=h8jJs6R_paJbPUMv74uGg@mail.gmail.com>
Subject: Re: [RFC PATCH 01/13] misc: atmel_ssc: add device tree DMA support
To: Bo Shen <voice.shen@atmel.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/2 Bo Shen <voice.shen@atmel.com>:
> Hi Richard,
>
>
> On 7/1/2013 16:39, Richard Genoud wrote:
>>
>> The ssc device has to fill the at_dma_slave structure with the
>> device tree informations.
>> Doing a of_dma_request_slave_channel()+dma_release_channel() for that
>> seems wrong (or at least not very clean).
>
>
> Please hold on of this, as to the ASoC dmaengine will deal with this. So, we
> not need do it manually.
>
> Now, I am working on it. And will send out the patch soon after testing OK.
Ok, I stay tuned !

Thanks !

Best regards,
Richard
