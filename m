Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbaGCJjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:39:18 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39365 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026AbaGCJjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:39:15 -0400
Message-ID: <53B524BC.6040301@mev.co.uk>
Date: Thu, 3 Jul 2014 10:39:08 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] staging: comedi: addi_apci_1564: miscellaneous
 fixes and cleanups
References: <1403930876-27678-1-git-send-email-chase.southwood@gmail.com> <1404353739-28607-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1404353739-28607-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-03 03:15, Chase Southwood wrote:
> This patchset moves a misplaced include to the proper file, swaps out an overly
> aggressive placement of apci1564_reset(), and cleans up apci1564_interrupt().
>
> Chase Southwood (3):
>    staging: comedi: addi_apci_1564: move addi_watchdog.h include to
>      addi_apci_1564.c
>    staging: comedi: addi_apci_1564: fix use of apci1564_reset() to
>      disable DI interrupts
>    staging: comedi: addi_apci_1564: clean up apci1564_interrupt()
>
>   .../comedi/drivers/addi-data/hwdrv_apci1564.c      |   2 -
>   drivers/staging/comedi/drivers/addi_apci_1564.c    | 139 +++++----------------
>   2 files changed, 32 insertions(+), 109 deletions(-)
>

Looks good!  You didn't list the v2 changes though.  Maybe you could 
summarize them here?

Reviewed-by: Ian Abbott <abbotti@mev.co.uk.>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
