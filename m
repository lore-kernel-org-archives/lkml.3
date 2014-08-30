Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaH3Kpw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:45:52 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:33746 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaH3Kpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:45:36 -0400
Message-ID: <5401AAE8.90209@mev.co.uk>
Date: Sat, 30 Aug 2014 11:43:52 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: usbduxsigma: fix sparse endianness warnings
References: <1409362855-1490-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1409362855-1490-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/14 02:40, Chase Southwood wrote:
> Sparse has many warnings like:
>
> drivers/staging/comedi/drivers/usbduxsigma.c:293:21: warning: cast to
> restricted __be32
>
> on lines on which devpriv->in_buf is passed to be32_to_cpu().  This
> suggests that this variable should actually be of type __be32.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> This is, as usual, compile tested only.  I tried to verify as best as I
> could that this is a sane change, but I am unable to test on the hardware.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
