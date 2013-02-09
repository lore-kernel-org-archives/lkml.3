Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3BIAqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:46:48 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51173 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab3BIAqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:46:46 -0500
Date: Fri, 8 Feb 2013 16:46:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: Other alloc/OOM message question
Message-ID: <20130209004644.GC31290@kroah.com>
References: <1360273587.27863.15.camel@joe-AO722>
 <20130208.174500.1518593039138341685.davem@davemloft.net>
 <1360369799.13487.5.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360369799.13487.5.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 04:29:59PM -0800, Joe Perches wrote:
> On Fri, 2013-02-08 at 17:45 -0500, David Miller wrote:
> > From: Joe Perches <joe@perches.com>
> > Date: Thu, 07 Feb 2013 13:46:27 -0800
> > > alloc failures already get standardized OOM
> > > messages and a dump_stack.
> 
> Does anyone know if all the other alloc's like
> dma_alloc_coherent, dma_alloc_noncoherent,
> pci_alloc_consistent always produce OOM messages
> via page_alloc/warn_alloc_failed for all arches?

If not, they should, to allow this type of cleanups.

thanks,

greg k-h
