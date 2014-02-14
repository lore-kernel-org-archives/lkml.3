Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBNIRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:17:30 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:35489 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaBNIR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:17:28 -0500
Message-ID: <1392365765.12787.89.camel@iivanov-dev>
Subject: Re: [PATCH] spi: core: Validate lenght of the transfers in message
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Brown <broonie@kernel.org>
Cc: Gerhard Sittig <gsi@denx.de>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Feb 2014 10:16:05 +0200
In-Reply-To: <20140214002627.GG28112@sirena.org.uk>
References: <1392302806-17267-1-git-send-email-iivanov@mm-sol.com>
	 <20140213212757.GM4524@book.gsilab.sittig.org>
	 <20140214002627.GG28112@sirena.org.uk>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 00:26 +0000, Mark Brown wrote: 
> On Thu, Feb 13, 2014 at 10:27:57PM +0100, Gerhard Sittig wrote:
> > On Thu, Feb 13, 2014 at 16:46 +0200, Ivan T. Ivanov wrote:
> 
> > > SPI transfer lenght should be a power-of-two multiple
> > > of eight bits.
> 
> > Are you suggesting that an SPI transfer cannot consist of e.g.
> > three bytes?  This would be surprising, and certainly would be
> > rather wrong an assumption.  Am I missing/misunderstanding
> > something?
> 
> The check is supposed to be verifying that the transfer is a whole
> number of the current SPI word size as I understand it (not actually
> looked at the change yet but that's where it came from, factored out of
> a driver).

Yes. Comment is not correct. Is this better?

"SPI transfer length should be multiple of SPI word size, where SPI
word size should be power-of-two multiple"

Regards,
Ivan

