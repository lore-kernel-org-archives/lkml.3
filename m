Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaBSLG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:06:56 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:47013 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaBSLGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:06:55 -0500
Message-ID: <5304903E.7070002@mev.co.uk>
Date: Wed, 19 Feb 2014 11:06:38 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Staging: comedi: addi-data: replace printk() with
 dev_err() in hwdrv_apci1564.c
References: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com> <1392795474-8713-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1392795474-8713-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-19 07:37, Chase Southwood wrote:
> There were a small handful of printk() calls in hwdrv_apci1564.c.  It is
> generally better to use dev_err() for error messages instead, so I
> switched all the printk() calls out, as well as cleaned up the error
> strings.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
