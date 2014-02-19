Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaBSLFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:05:47 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:46996 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaBSLFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:05:45 -0500
Message-ID: <53048FFD.3070808@mev.co.uk>
Date: Wed, 19 Feb 2014 11:05:33 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Staging: comedi: addi-data: cleanup comments in hwdrv_apci1564.c
References: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-19 07:36, Chase Southwood wrote:
> hwdrv_apci1564.c had a lot of commented out conditional statements that
> were often identical to other un-commented out statements nearby, so it
> should be safe to just delete all of these commented out lines.  This
> patch also converts the remaining comments to the preferred kernel style
> for comments.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
