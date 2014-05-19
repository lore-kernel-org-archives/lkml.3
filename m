Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbaESQyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:54:44 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58513 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361AbaESQym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:54:42 -0400
Message-ID: <537A3742.5060508@mev.co.uk>
Date: Mon, 19 May 2014 17:54:26 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sheetal Tigadoli <sheetal.tigadoli@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <Ian.Abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>
Subject: Re: [PATCH] staging: comedi: Fixes Coding Style Warning in file das08.h
References: <1399544017-5906-1-git-send-email-sheetal.tigadoli@gmail.com>
In-Reply-To: <1399544017-5906-1-git-send-email-sheetal.tigadoli@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-08 11:13, Sheetal Tigadoli wrote:
> The Patch fixes following Warnings, found using checkpatch.pl, in file das08.h
>
> ./scripts/checkpatch.pl --file --terse drivers/staging/comedi/drivers/das08.h
> drivers/staging/comedi/drivers/das08.h:43: WARNING: line over 80 characters
> total: 0 errors, 1 warnings, 50 lines checked
>
> Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@gmail.com>
> ---
>   drivers/staging/comedi/drivers/das08.h |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)

Thanks!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
