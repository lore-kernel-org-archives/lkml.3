Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbaD3IsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:48:10 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51094 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbaD3IsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:48:07 -0400
Message-ID: <5360B8AB.9050309@mev.co.uk>
Date: Wed, 30 Apr 2014 09:47:39 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6 v3] staging: comedi: addi_apci_1564: simplify the
 PCI bar reading and don't read the unused bars
References: <1398562636-5900-1-git-send-email-chase.southwood@gmail.com> <1398844679-2923-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1398844679-2923-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-30 08:57, Chase Southwood wrote:
> This driver only uses PCI bar 0 (devpriv->i_IobaseAmcc), and PCI bar 1
> (dev->iobase), don't bother reading the unused PCI bars.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> 2: Bad PCI bar numbers corrected.
>
> 3: Fixed silly typos in the changelog
>
>   drivers/staging/comedi/drivers/addi_apci_1564.c | 11 ++---------
>   1 file changed, 2 insertions(+), 9 deletions(-)

Okay now!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
