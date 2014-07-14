Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaGNJPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:15:49 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:48210 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbaGNJPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:15:41 -0400
Message-ID: <53C39FA2.1070800@mev.co.uk>
Date: Mon, 14 Jul 2014 10:15:14 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] staging: comedi: addi_apci_1564: driver no longer
 needs to include addi_common.h
References: <1405204956-1559-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1405204956-1559-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-12 23:42, Chase Southwood wrote:
> This driver no longer depends on anything in addi_common.h, save for a
> few headers that it was including indirectly.  Remove the include of
> addi_common.h and add the includes of <linux/interrupt.h>
> and <linux/sched.h> directly.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>   drivers/staging/comedi/drivers/addi_apci_1564.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
