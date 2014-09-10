Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaIJIo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:44:29 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38744 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaIJIo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:44:26 -0400
Message-ID: <54100F64.9010604@mev.co.uk>
Date: Wed, 10 Sep 2014 09:44:20 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] staging: comedi: hwdrv_apci1320: style cleanups
References: <cover.1409983606.git.chase.southwood@gmail.com>
In-Reply-To: <cover.1409983606.git.chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-10 07:03, Chase Southwood wrote:
> This patchset begins by cleaning up the mess of the comments in
> this driver, then follows that with three very small and trivial
> checkpatch warning fixes.
>
> Chase Southwood (4):
>    staging: comedi: hwdrv_apci3120: clean up comments
>    staging: comedi: hwdrv_apci3120: add a blank line after declarations
>    staging: comedi: hwdrv_apci3120: else is not useful after return
>    staging: comedi: hwdrv_apci3120: remove void function return statement
>
>   .../comedi/drivers/addi-data/hwdrv_apci3120.c      | 369 +++++++--------------
>   1 file changed, 119 insertions(+), 250 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
