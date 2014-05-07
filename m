Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaEGJId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:08:33 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:37866 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbaEGJIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:08:31 -0400
Message-ID: <5369F807.5020206@mev.co.uk>
Date: Wed, 7 May 2014 10:08:23 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] staging: comedi: addi_apci_1564: remove boardinfo
References: <1399446163-30234-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1399446163-30234-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/05/07 08:02 AM, Chase Southwood wrote:
> This patchset removes the last dependency on this driver's boardinfo (the
> timer subdevice init), and then removes the boardinfo from the driver.
> 
> To be applied on top of my prior patchset "staging: comedi:
> addi_apci_1564: further cleanups"
> 
> Chase Southwood (2):
>   staging: comedi: addi_apci_1564: remove check for timer subdevice
>   staging: comedi: addi_apci_1564: remove boardinfo
> 
>  drivers/staging/comedi/drivers/addi_apci_1564.c | 40 +++++++------------------
>  1 file changed, 10 insertions(+), 30 deletions(-)
> 

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
