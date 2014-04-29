Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaD2NPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:15:38 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49045 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaD2NPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:15:37 -0400
Message-ID: <535FA5ED.5030700@mev.co.uk>
Date: Tue, 29 Apr 2014 14:15:25 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6 v2] staging: comedi: addi_apci_1564: board has 32
 digital inputs
References: <1398562623-5727-1-git-send-email-chase.southwood@gmail.com> <1398760463-18638-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1398760463-18638-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-29 09:34, Chase Southwood wrote:
> This board always has 32 digital inputs. Remove the test when
> initializing the subdevice.
>
> Also, since this board is the only one supported by this driver,
> remove the boardinfo about the digital inputs and just use the
> data directly in the subdevice init.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> 2: Changed incorrect title.
>
>   drivers/staging/comedi/drivers/addi_apci_1564.c | 26 +++++++++----------------
>   1 file changed, 9 insertions(+), 17 deletions(-)

Looks good.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
