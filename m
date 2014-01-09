Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaAIIpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:45:05 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41118 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaAIIo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:44:58 -0500
MIME-Version: 1.0
In-Reply-To: <1389256274-6308-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
References: <1389256274-6308-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
Date: Thu, 9 Jan 2014 17:44:56 +0900
Message-ID: <CANqRtoSko2Ctwkq-Q8TTLmkjNQPFi5CPxyvHt_NSxq4qBAX+BQ@mail.gmail.com>
Subject: Re: [PATCH CFT] ARM:SHMOBILE: Enable AUTO_ZRELADDR by default
From: Magnus Damm <magnus.damm@gmail.com>
To: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: "Simon Horman [Horms]" <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, linaro-kernel@lists.linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 5:31 PM, panchaxari
<panchaxari.prasannamurthy@linaro.org> wrote:
> This patch enables AUTO_ZRELADDR as default config to Renasas R-Mobile and
> SH-Mobile platforms.
>
> AUTO_ZRELADDR config enables auto calculation of the decompressed kernel image
> address. AUTO_ZRELADDR config is mutually exclusive to ZBOOT_ROM, and also
> assumes zImage to be loaded in the first 128MiB from start of memory.
>
> CFT::Call For Testing
>
> Requesting maintainers of R-Mobile and SH-Mobile platforms to evaluate the
> changes on the board and comment, as I dont have the board for testing, and
> also requesting an ACK.
>
> Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>

Thanks for the patch. I believe we enable this for the multiplatform
case already. The legacy case still supports ZBOOT_ROM and boards that
don't work with AUTO_ZRELADDR, so because of this we intentionally
don't enable it there.

What is the reason you want to add it here?

Thanks,

/ magnus
