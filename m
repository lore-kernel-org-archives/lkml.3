Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaH2HEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:04:51 -0400
Received: from ozlabs.org ([103.22.144.67]:56103 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaH2HEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:04:50 -0400
Message-ID: <1409295887.9191.6.camel@concordia>
Subject: Re: [PATCH] drivers: char: hw_random: printk replacement
From: Michael Ellerman <mpe@ellerman.id.au>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Olof Johansson <olof@lixom.net>, linuxppc-dev@lists.ozlabs.org,
        linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 29 Aug 2014 17:04:47 +1000
In-Reply-To: <1409238178-16496-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1409238178-16496-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-28 at 20:32 +0530, Sudip Mukherjee wrote:
> as pr_* macros are more preffered over printk, so printk replaced with corresponding pr_* macros
 
I suppose ...

>  drivers/char/hw_random/pasemi-rng.c  |  2 +-
>  drivers/char/hw_random/pseries-rng.c |  2 +-

These look OK to me.

cheers


