Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaIAJDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:03:34 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38680 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbaIAJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:03:33 -0400
Message-ID: <5404365F.5060306@mev.co.uk>
Date: Mon, 1 Sep 2014 10:03:27 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: usbdux: fix more sparse endianness warnings
References: <1409514263-15251-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1409514263-15251-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-31 20:44, Chase Southwood wrote:
> Sparse shows a couple of warnings like:
>
> drivers/staging/comedi/drivers/usbdux.c:889:20: warning: incorrect type in assignment (different base types)
> drivers/staging/comedi/drivers/usbdux.c:889:20:    expected unsigned short [unsigned] [short] [usertype] <noident>
> drivers/staging/comedi/drivers/usbdux.c:889:20:    got restricted __le16 [usertype] <noident>
>
> This is the result of a couple of calls to cpu_to_le16() being assigned to
> uint16_t typed variables.  Switch the types of these variables/pointers to
> __le16 accordingly.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Suggested-by: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>
>   drivers/staging/comedi/drivers/usbdux.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
