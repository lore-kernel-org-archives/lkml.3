Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaIHUmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:42:35 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63895 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaIHUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:42:33 -0400
Message-ID: <540DFEDA.2060202@gmail.com>
Date: Mon, 08 Sep 2014 21:09:14 +0200
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: octeon-hcd: removed unwanted return from void
 functions
References: <1410196395-4595-1-git-send-email-nitinkuppelur@gmail.com> <20140908185923.GA10550@drone.musicnaut.iki.fi>
In-Reply-To: <20140908185923.GA10550@drone.musicnaut.iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaro,

Thanks for review. I will correct the commit log length and resend the patch.

About the __cvmx_usb_perform_complete():
Here return statement has associated label. Due to which it will add
compilation warning. So I am not handling this.

Note:
Also checkpatch.pl does not complain about this.

Regards,
Nitin

> Please format line length to <= 76 characters in the commit log.
> 
> Maybe you could fix __cvmx_usb_perform_complete() as well?
> 
> A.
> 
