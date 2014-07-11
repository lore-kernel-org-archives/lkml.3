Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaGKKYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:24:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58569 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbaGKKYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:24:44 -0400
Message-ID: <53BFBB65.20402@mev.co.uk>
Date: Fri, 11 Jul 2014 11:24:37 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] staging: comedi: addi_apci_1564: small fixes in apci1564_auto_attach()
 and apci1564_detach()
References: <cover.1405050794.git.chase.southwood@gmail.com>
In-Reply-To: <cover.1405050794.git.chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-11 05:00, Chase Southwood wrote:
> This is a small patchset containing a handful of fixes to the ADDI-DATA
> APCI1564 driver that I would like to get out of the way before I forget
> to take care of them.  From here, I will move to start fixing the
> digital input/timer/counters/watchdog functionality of the board.
>
> Chase Southwood (4):
>    staging: comedi: addi_apci_1564: remove len_chanlist from di and do
>      subdevices
>    staging: comedi: addi_apci_1564: remove unnecessary dev->board_name
>      initialization
>    staging: comedi: addi_apci_1564: remove null check of devpriv in
>      apci1564_detach()
>    staging: comedi: addi_apci_1564: fix s->maxdata assignment in do
>      subdevice init.
>
>   drivers/staging/comedi/drivers/addi_apci_1564.c | 18 +++++-------------
>   1 file changed, 5 insertions(+), 13 deletions(-)
>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
