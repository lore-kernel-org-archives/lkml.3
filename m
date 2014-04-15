Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaDOJKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:10:31 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59365 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbaDOJK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:10:26 -0400
Message-ID: <534CF77C.9090906@mev.co.uk>
Date: Tue, 15 Apr 2014 10:10:20 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] staging: comedi: addi_apci_1564: remove use of devpriv->iobase
References: <1397541235-2574-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1397541235-2574-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-15 06:53, Chase Southwood wrote:
> devpriv->iobase is currently being used to hold the iobase address used to
> read/write the board's registers.  The same address is stored in the
> comedi_device dev->iobase.  We use that instead.  The eventual goal is to
> decrease the driver's use of the struct addi_private, so that it may
> eventually use a much slimmer specialized private struct instead, as the
> other addi_apci_* drivers do.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> This is a (small) first patchset for my more complete cleanup of
> addi_apci_1564 driver.  Hartley, I'd appreciate any review you have
> wrt these specific patches, but also whether I have chosen a good place
> to start.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
