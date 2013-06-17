Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3FQXTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:19:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3FQXTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:19:53 -0400
Date: Mon, 17 Jun 2013 16:19:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 5/8] FMC: add a software carrier driver
Message-ID: <20130617231952.GD12984@kroah.com>
References: <cover.1371018406.git.rubini@gnudd.com>
 <6abb560f385a1dae57359ecb0dd98336d0e770bf.1371018406.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6abb560f385a1dae57359ecb0dd98336d0e770bf.1371018406.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:14:09AM +0200, Alessandro Rubini wrote:
> --- /dev/null
> +++ b/drivers/fmc/fmc-fakedev.c
> @@ -0,0 +1,349 @@
> +/*
> + * Copyright (C) 2012 CERN (www.cern.ch)
> + * Author: Alessandro Rubini <rubini@gnudd.com>
> + *
> + * Released to the public domain, as example to be reused

I'm sorry, but that's not a "real" license in almost all countries, and
especially not in the USA, where I would have to be applying this patch.

If you want this to be used by anyone, why not just make it BSD?  That
would make the lawyers happy, and allow me to accept this patch {hint}.

thanks,

greg k-h
