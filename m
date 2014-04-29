Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbaD2NRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:17:08 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49050 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbaD2NRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:17:05 -0400
Message-ID: <535FA64D.90007@mev.co.uk>
Date: Tue, 29 Apr 2014 14:17:01 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6 v2] staging: comedi: addi_apci_1564: remove unnecessary
 info from boardinfo
References: <1398562693-6140-1-git-send-email-chase.southwood@gmail.com> <1398760637-19143-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1398760637-19143-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-29 09:37, Chase Southwood wrote:
> The i_IorangeBase1, i_PCIEeprom, and pc_EepromChip data in the boardinfo
> was only needed to work out the usage of the PCI bars.  Now that that is
> squared away, this info is no longer needed and can be removed.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> 2: Incorrect patch title fixed.
>
>   drivers/staging/comedi/drivers/addi_apci_1564.c | 3 ---
>   1 file changed, 3 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
