Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaH3KrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:47:04 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:33756 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaH3KrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:47:02 -0400
Message-ID: <5401AB39.9090104@mev.co.uk>
Date: Sat, 30 Aug 2014 11:45:13 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: addi_apci_1564: move boilerplate text
 to addi_apci_1564.c
References: <1409378101-20134-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1409378101-20134-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/14 06:55, Chase Southwood wrote:
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>   .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 23 ----------------------
>   drivers/staging/comedi/drivers/addi_apci_1564.c    | 23 ++++++++++++++++++++++
>   2 files changed, 23 insertions(+), 23 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
