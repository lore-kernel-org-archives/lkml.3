Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaEVJZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:25:49 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:37753 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbaEVJZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:25:48 -0400
Message-ID: <537DC298.1000200@mev.co.uk>
Date: Thu, 22 May 2014 10:25:44 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: comedi: addi_apci_1564: move apci1564_do_insn_bits()
 to addi_apci_1564.c
References: <1400719209-21452-1-git-send-email-chase.southwood@gmail.com> <1400719275-21780-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1400719275-21780-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-22 01:41, Chase Southwood wrote:
> This function is already compliant with the comedi API and is behaving as
> comedi core expects.  This patch moves it out of
> addi-data/hwdrv_apci1564.c and into the driver proper since no further
> work needs to be done on it.
>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> ---
> Just a couple patches in this set, but with these out of the way, the
> next patchset can focus entirely on getting the change-of-state interrupt
> functionality working.  Made sense to just finish up with DI/DO and start
> COS interrupts separately.
>
>   .../staging/comedi/drivers/addi-data/hwdrv_apci1564.c   | 17 -----------------
>   drivers/staging/comedi/drivers/addi_apci_1564.c         | 17 +++++++++++++++++
>   2 files changed, 17 insertions(+), 17 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
