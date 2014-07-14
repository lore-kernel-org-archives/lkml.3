Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaGNJXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:23:11 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:48231 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaGNJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:23:07 -0400
Message-ID: <53C3A16B.6030801@mev.co.uk>
Date: Mon, 14 Jul 2014 10:22:51 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: comedi: addi_apci_1564: use addi_watchdog
 module to init watchdog subdevice
References: <1405204956-1559-1-git-send-email-chase.southwood@gmail.com> <1405205049-1828-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1405205049-1828-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-12 23:44, Chase Southwood wrote:
> Use the addi_watchdog module to provide support for the watchdog
> subdevice.
>
> Also, rearrange the subdevice init blocks so that the order makes sense.
> Digital input/output subdevices and subdevices for DI/DO interrupt
> support, followed by timer/counter/watchdog subdevices is the new order.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>   drivers/staging/comedi/drivers/addi_apci_1564.c | 34 +++++++++++++++----------
>   1 file changed, 20 insertions(+), 14 deletions(-)

I don't think the subdevice order matters that much, and I prefer to 
keep them stable, but since this driver is in such a state of flux, it 
doesn't really matter.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
