Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaCKObb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:31:31 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51946 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaCKOb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:31:29 -0400
Message-ID: <531F1E2B.3040300@mev.co.uk>
Date: Tue, 11 Mar 2014 14:31:07 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Fred Akers <knivey@botops.net>, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: apci_1564: Fix long CamelCase function
 names
References: <1394350009-23464-1-git-send-email-knivey@botops.net>
In-Reply-To: <1394350009-23464-1-git-send-email-knivey@botops.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-09 07:26, Fred Akers wrote:
> This patch fixes a few function names that are very long and are
> not in the correct naming style
>
> Signed-off-by: Fred Akers <knivey@botops.net>
> ---
>   .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 62 ++++++++++------------
>   drivers/staging/comedi/drivers/addi_apci_1564.c    | 16 +++---
>   2 files changed, 36 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> index a31e115..cb426e7 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> @@ -116,7 +116,7 @@ static unsigned int ui_InterruptData, ui_Type;
>
>   /*
>   +----------------------------------------------------------------------------+
> -| Function   Name   : int i_APCI1564_ConfigDigitalInput                      |
> +| Function   Name   : int i_apci1564_di_config                      |

It would be nice to get rid of the silly i_, v_ prefixes as well!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
