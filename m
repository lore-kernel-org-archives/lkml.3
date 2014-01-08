Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaAHKZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:25:40 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54635 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaAHKZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:25:38 -0500
Message-ID: <52CD279B.6020203@gmail.com>
Date: Wed, 08 Jan 2014 11:25:31 +0100
From: Richard Genoud <richard.genoud@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>
CC: broonie@kernel.org, nicolas.ferre@atmel.com, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] spi: atmel: Refactor spi-atmel to use SPI framework queue
References: <1389160188-4030-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1389160188-4030-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 06:49, Wenyou Yang wrote:
> Replace the deprecated master->transfer with transfer_one_message()
> and allow the SPI subsystem handle all the queuing of messages.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
> Hi Mark,
> 
> The patch is based on for-next branch of
> 	git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git
> 
> It is tested on sama5d3xek and at91sam9m10g45ek board.

And the bug I was seeing with SPI_IOC_MESSAGE (cf https://lkml.org/lkml/2013/10/8/269 )
is now gone !

Tested on at91sam9g35-ek

Tested-by: Richard Genoud <richard.genoud@gmail.com>


