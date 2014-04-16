Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaDPM3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:29:52 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34153 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016AbaDPM3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:29:50 -0400
Message-ID: <534E778F.5090007@mev.co.uk>
Date: Wed, 16 Apr 2014 13:29:03 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] staging: comedi: addi_apci_1564: fixup and absorb
 apci1564_reset()
References: <1397631465-13169-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1397631465-13169-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-16 07:57, Chase Southwood wrote:
> We can remove this function from the boardinfo and move the code from
> hwdrv_apci1564.c into addi_apci_1564.c since it is the only reset function
> used by the driver. The function was also messy and failed to reset a few
> registers, these issues were fixed on the move.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 2: *Changed order of register accesses for digital input registers back to
> original ordering.
> *Removed read of digital output status register and reordered the accesses
> of digital output registers to agree with the order found in addi_apci_2032.
> *Fixed copy/paste error in the counter register reset lines.
>
> Ian, I addressed your comments as above.
> Chase

Looks good.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
