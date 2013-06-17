Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3FQXPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:15:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3FQXPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:15:03 -0400
Date: Mon, 17 Jun 2013 16:15:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/8] FMC: add core bus driver
Message-ID: <20130617231502.GA12984@kroah.com>
References: <cover.1371018406.git.rubini@gnudd.com>
 <3e9f6b2fb7cd202da9bbb6371b27ff302ca8b860.1371018406.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e9f6b2fb7cd202da9bbb6371b27ff302ca8b860.1371018406.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:13:47AM +0200, Alessandro Rubini wrote:
> +static void fmc_release(struct device *dev)
> +{
> +	struct fmc_device *fmc = container_of(dev, struct fmc_device, dev);
> +
> +	kfree(fmc);
> +}

I read so many people who write new bus / device code that get this
wrong, that I'm so overjoyed when it is written correctly, that I'm
almost willing to just blindly accept this whole patchset.

Almost :)

Seriously, very nice job on the whole driver model integration for this
code.

thanks,

greg k-h
