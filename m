Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaJSKtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 06:49:23 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39217 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaJSKtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 06:49:20 -0400
Message-ID: <54439713.7020907@gmail.com>
Date: Sun, 19 Oct 2014 13:48:51 +0300
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Fabio Falzoi <fabio.falzoi84@gmail.com>, gregkh@linuxfoundation.org
CC: micky_ching@realsil.com.cn, joe@perches.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Staging: rts5208: rtsx_reset_chip style clean up
References: <1413712554-4872-1-git-send-email-fabio.falzoi84@gmail.com>
In-Reply-To: <1413712554-4872-1-git-send-email-fabio.falzoi84@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.10.19 12:55, Fabio Falzoi wrote:
> Clean up the code in rtsx_reset_chip function defining two new helper
> functions rtsx_reset_aspm and rtsx_enable_pcie_intr.
> Specifically, the following checkpatch warnings are corrected:
> * PARENTHESIS_ALIGNMENT at rows 271, 302, 343 and 346
> * LONG_LINE at rows 294, 313 and 315
> * BRACES at rowa 320 and 351
> This patch is inspired by the following post on LKML regarding another
> clean up for rts5208 module:
> http://www.spinics.net/lists/linux-driver-devel/msg55038.html
> 
> Fabio Falzoi (2):
>   Staging: rts5208: helper function to manage aspm during reset
>   Staging: rts5208: helper function to enable interrupts during reset
> 
>  drivers/staging/rts5208/rtsx_chip.c | 168 +++++++++++++++++++-----------------
>  1 file changed, 87 insertions(+), 81 deletions(-)
> 
Could you please remake this patch set against the staging-testing
branch? 
https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/commit/?h=staging-testing&id=ccf2d2456648ce84090ea1f37bd6774bafa99f00
This will break your patch on staging-testing.
