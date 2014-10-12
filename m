Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaJLCZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 22:25:25 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37411 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJLCZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 22:25:23 -0400
Date: Sat, 11 Oct 2014 19:25:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark D Rustad <mrustad@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Torsten Duwe <duwe@lst.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Jason Cooper <jason@lakedaemon.net>,
        Amit Shah <amit.shah@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: hw_random: core.c:  Changed from using strncpy to
 strlcpy
Message-ID: <20141012022518.GA29109@roeck-us.net>
References: <1413067004-10925-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <09FC08CC-027E-443A-83C3-CC4C1D978743@gmail.com>
 <20141012021122.GA10822@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012021122.GA10822@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 07:11:22PM -0700, Guenter Roeck wrote:
> On Sat, Oct 11, 2014 at 05:27:41PM -0700, Mark D Rustad wrote:
> > On Oct 11, 2014, at 3:36 PM, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
> > 
> > > Changed from using strncpy to strlcpy to simplify the code
> > 
> > Actually you changed from using strncat to strlcat.
> > 
> ... and changed the length parameter along the way, making the length check
> overall quite worthless and introducing a _real_ problem.
> 
Me talking nonsense; ignore this noise.

Guenter
