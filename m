Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3ETPvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:51:24 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.202]:53041 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757154Ab3ETPvU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:51:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1369065073!25919344!12
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 May 2013 10:49:00 -0500
Subject: RE: [PATCH 1/7] input: ep93xx_keypad: Pass correct pointer to
 free_irq()
Thread-Topic: [PATCH 1/7] input: ep93xx_keypad: Pass correct pointer to
 free_irq()
Thread-Index: Ac5VaZUXSeFrpYn2RX+6d5ye+vrcggAB8VtQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DA656F56D@AUSP01VMBX24.collaborationhost.net>
References: <1369061486-28226-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1369061486-28226-1-git-send-email-lars@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 20, 2013 7:51 AM, Lars-Peter Clausen wrote:
> free_irq() expects the same pointer that was passed to request_irq(), otherwise
> the IRQ is not freed.

<snip>

> Cc: H Hartley Sweeten <hartleys@visionengravers.com>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/input/keyboard/ep93xx_keypad.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks,

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

