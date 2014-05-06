Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550AbaEFJT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:19:58 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35736 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934484AbaEFJTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:19:54 -0400
Message-ID: <5368A934.1060905@mev.co.uk>
Date: Tue, 6 May 2014 10:19:48 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] staging: comedi: addi_apci_1564: Further cleanups
References: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-03 08:54, Chase Southwood wrote:
> Latest patchset in a continuing cleanup of addi_apci_1564.c.  Main focus
> is on the auto_attach() function, but also cleaning up some of the old addi
> common code wrappers.
>
> To be applied on top of my prior patchset to this file (the one beginning
> with [PATCH 1/6] staging: comedi: addi_apci_1564: remove eeprom support code)
>
> Chase Southwood (4):
>    staging: comedi: addi_apci_1564: board has 32 digital outputs
>    staging: comedi: addi_apci_1564: don't allocate unused subdevices
>    staging: comedi: addi_apci_1564: absorb apci1564_reset()
>    staging: comedi: addi_apci_1564: call apci1564_interrupt() directly
>
>   .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 32 -------
>   drivers/staging/comedi/drivers/addi_apci_1564.c    | 98 ++++++++++------------
>   2 files changed, 45 insertions(+), 85 deletions(-)

Thumbs up from me too!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
