Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaHLJ3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:29:10 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52826 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaHLJ3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:29:08 -0400
Message-ID: <53E9DE5D.3010403@mev.co.uk>
Date: Tue, 12 Aug 2014 10:29:01 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] staging: comedi: addi_apci_1564: miscellaneous cleanups
References: <cover.1407804777.git.chase.southwood@gmail.com>
In-Reply-To: <cover.1407804777.git.chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-12 03:02, Chase Southwood wrote:
> This patchset removes an uncorrect and unneeded insn_config operation,
> strips out remaining in-driver watchdog subdevice code, and cleans up the
> driver's register map defines.
>
> Chase Southwood (3):
>    staging: comedi: addi_apci_1564: remove apci1564_do_config
>    staging: comedi: addi_apci_1564: Remove in-driver watchdog support
>      code
>    staging: comedi: addi_apci_1564: tidy register map defines
>
>   .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 158 +++++++--------------
>   drivers/staging/comedi/drivers/addi_apci_1564.c    |  20 +--
>   2 files changed, 60 insertions(+), 118 deletions(-)
>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
