Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaIAJYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:24:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38717 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbaIAJYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:24:44 -0400
Message-ID: <54043B58.6030108@mev.co.uk>
Date: Mon, 1 Sep 2014 10:24:40 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: usbduxsigma: fix more sparse endianness
 warnings
References: <1409514300-15493-1-git-send-email-chase.southwood@gmail.com> <54043B09.4000602@mev.co.uk>
In-Reply-To: <54043B09.4000602@mev.co.uk>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-01 10:23, Ian Abbott wrote:
> On 2014-08-31 20:45, Chase Southwood wrote:
>> Sparse shows a couple of warnings like:
>>
>> drivers/staging/comedi/drivers/usbduxsigma.c:787:23: warning: cast to
>> restricted __be32
>>
>> Looking at the indicated lines shows that the issue is caused by an
>> incorrect cast to uint32_t instead of __be32.  Fix this cast.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
>> ---
>>   drivers/staging/comedi/drivers/usbduxsigma.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>

I meant:

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
