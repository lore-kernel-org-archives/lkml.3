Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaB1Q0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:26:22 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:33344 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaB1Q0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:26:20 -0500
Message-ID: <5310B8A7.3040305@mev.co.uk>
Date: Fri, 28 Feb 2014 16:26:15 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: addi-data: remove unnecessary variable
 initializations in hwdrv_apci035.c
References: <1393572645-9470-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1393572645-9470-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-28 07:30, Chase Southwood wrote:
> Nearly every variable in hwdrv_apci035.c is initialized to 0 when it is
> declared, and then set to some other value before ever being used.  As
> such, we can remove all of these initializations.  They are accomplishing
> nothing.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>   .../comedi/drivers/addi-data/hwdrv_apci035.c       | 26 +++++++++++-----------
>   1 file changed, 13 insertions(+), 13 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
