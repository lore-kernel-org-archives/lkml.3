Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaFBR7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:59:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62581 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927AbaFBR7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:59:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19RqF9H0LwSDV3gAsLY0P8bPP5AKZaZVm0=
X-DKIM: OpenDKIM Filter v2.0.1 titan 71BDB58565B
Date: Mon, 2 Jun 2014 13:59:27 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: James A Shackleford <shack@linux.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: skein: fix sparse warning for static arrays
Message-ID: <20140602175927.GA8664@titan.lakedaemon.net>
References: <1401667656-17926-1-git-send-email-shack@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401667656-17926-1-git-send-email-shack@linux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

On Sun, Jun 01, 2014 at 08:07:35PM -0400, James A Shackleford wrote:
> This patch fixes the following sparse warnings:
> 
> skein_iv.h:23:11: warning: symbol 'SKEIN_256_IV_128' was not declared. Should it be static?
> skein_iv.h:31:11: warning: symbol 'SKEIN_256_IV_160' was not declared. Should it be static?
> skein_iv.h:39:11: warning: symbol 'SKEIN_256_IV_224' was not declared. Should it be static?
> skein_iv.h:47:11: warning: symbol 'SKEIN_256_IV_256' was not declared. Should it be static?
> skein_iv.h:55:11: warning: symbol 'SKEIN_512_IV_128' was not declared. Should it be static?
> skein_iv.h:67:11: warning: symbol 'SKEIN_512_IV_160' was not declared. Should it be static?
> skein_iv.h:79:11: warning: symbol 'SKEIN_512_IV_224' was not declared. Should it be static?
> skein_iv.h:91:11: warning: symbol 'SKEIN_512_IV_256' was not declared. Should it be static?
> skein_iv.h:103:11: warning: symbol 'SKEIN_512_IV_384' was not declared. Should it be static?
> skein_iv.h:115:11: warning: symbol 'SKEIN_512_IV_512' was not declared. Should it be static?
> skein_iv.h:127:11: warning: symbol 'SKEIN_1024_IV_384' was not declared. Should it be static?
> skein_iv.h:147:11: warning: symbol 'SKEIN_1024_IV_512' was not declared. Should it be static?
> skein_iv.h:167:11: warning: symbol 'SKEIN_1024_IV_1024' was not declared. Should it be static?
> 
> by declaring the initialization vectors in question as static.  The header
> skein_iv.h is only included by skein.c
> 
> Signed-off-by: James A Shackleford <shack@linux.com>
> ---
>  drivers/staging/skein/skein_iv.h |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)

Thanks for the patch.  I see the first one you sent was already merged
by Greg.

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
