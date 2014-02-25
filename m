Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaBYJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:56:24 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:51851 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaBYJ4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:56:21 -0500
Message-ID: <530C68B7.4000500@mev.co.uk>
Date: Tue, 25 Feb 2014 09:56:07 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: addi-data: clean-up variable use in
 hwdrv_apci035.c
References: <1393316127-28777-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1393316127-28777-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-25 08:15, Chase Southwood wrote:
> The static variable ui_Command is as of right now being cleared to a
> value of zero between everytime that it writes to a port and then takes a
> new value from a port.  Seems like this zeroing is unnecessary, so we can
> just remove these lines.

The description is slightly wrong as the variable isn't static storage 
class.

>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> This sort of thing seems like a copy/paste sort of error to me, but there
> could as easily be some reason here that I'm missing that this is needed
> here.  My first impression, however, was that this extra clearing is
> useless.

Yes, the extra clearing was useless.  There are also some useless 
initializers for this variable and others.

Fine, apart from the description.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
