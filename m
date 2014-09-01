Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaIAJkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:40:37 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38801 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbaIAJkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:40:36 -0400
Message-ID: <54043F0F.2060104@mev.co.uk>
Date: Mon, 1 Sep 2014 10:40:31 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] staging: comedi: hwdrv_apci1500: coding style cleanups
References: <cover.1409542016.git.chase.southwood@gmail.com>
In-Reply-To: <cover.1409542016.git.chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-01 04:37, Chase Southwood wrote:
> This patchset begins by removing unneeded braces and commented out lines
> of code, and then tidies whitespace issues that are revealed after the
> braces/dead code is removed.
>
> Chase Southwood (4):
>    staging: comedi: hwdrv_apci1500: remove unneeded braces
>    staging: comedi: hwdrv_apci1500: remove commented out code
>    staging: comedi: hwdrv_apci1500: clean some whitespace style issues
>    staging: comedi: hwdrv_apci1500: miscellaneous cleanup
>
>   .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 349 +++++++++------------
>   1 file changed, 149 insertions(+), 200 deletions(-)
>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
