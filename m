Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3KYKNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:13:14 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:41904 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3KYKNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:13:12 -0500
Message-ID: <529322B2.4090702@mev.co.uk>
Date: Mon, 25 Nov 2013 10:13:06 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Conrad Gomes <conrad.s.j.gomes@gmail.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "joe@perches.com" <joe@perches.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/7] Staging: comedi: fix coding style issues in unioxx5.c
References: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
In-Reply-To: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-11-21 19:57, Conrad Gomes wrote:
> This series contains various fixes to coding style issues in unioxx5.c
> found by checkpatch.pl and due to the usage of pr_err instead of the
> preferred dev_err type functions for device drivers.
>
> Conrad Gomes (7):
>    Staging: comedi: fix line over 80 character warning in unioxx5.c
>    Staging: comedi: fix line over 80 character warning in unioxx5.c
>    Staging: comedi: change printk to dev_err/dev_dbg in unioxx5.c
>    Staging: comedi: change pr_err to dev_err in __unioxx5_analog_read
>    Staging: comedi: change pr_err to dev_err in __unioxx5_digital_write
>    Staging: comedi: change pr_err to dev_err in __unioxx5_analog_write
>    Staging: comedi: remove MACRO pr_fmt in unioxx5.c
>
>   drivers/staging/comedi/drivers/unioxx5.c |   50 ++++++++++++++++++------------
>   1 file changed, 31 insertions(+), 19 deletions(-)

Looks okay!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
