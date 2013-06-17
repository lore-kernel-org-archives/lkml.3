Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3FQXUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:20:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3FQXUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:20:21 -0400
Date: Mon, 17 Jun 2013 16:20:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 6/8] FMC: add a software mezzanine driver
Message-ID: <20130617232019.GE12984@kroah.com>
References: <cover.1371018406.git.rubini@gnudd.com>
 <7be26b13f841e433176a5d77ca9de1dd964b153a.1371018406.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7be26b13f841e433176a5d77ca9de1dd964b153a.1371018406.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:14:20AM +0200, Alessandro Rubini wrote:
> +++ b/drivers/fmc/fmc-trivial.c
> @@ -0,0 +1,101 @@
> +/*
> + * Copyright (C) 2012 CERN (www.cern.ch)
> + * Author: Alessandro Rubini <rubini@gnudd.com>
> + *
> + * Released to the public domain, as example to be reused

Same license issue, sorry.

greg k-h
