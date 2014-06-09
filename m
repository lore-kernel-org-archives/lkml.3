Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaFIKB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:01:57 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:46382 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbaFIKB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:01:56 -0400
Message-ID: <5395860E.3070000@mev.co.uk>
Date: Mon, 9 Jun 2014 11:01:50 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Anton Protopopov <a.s.protopopov@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: check the return value of kobject_set_name
References: <1402149415-20037-1-git-send-email-a.s.protopopov@gmail.com>
In-Reply-To: <1402149415-20037-1-git-send-email-a.s.protopopov@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-07 14:56, Anton Protopopov wrote:
> Added a check of the return value of the kobject_set_name function.
>
> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> ---
>   drivers/staging/comedi/comedi_fops.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
