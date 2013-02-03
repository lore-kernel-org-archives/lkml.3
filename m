Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3BCUMM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 15:12:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:42622 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab3BCUMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 15:12:08 -0500
Date: Sun, 3 Feb 2013 21:14:18 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Mihai Moldovan <ionic@ionic.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Adam Jackson <ajax@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        stathis <stathis@npcglib.org>
Subject: Re: [ 092/128] iommu/intel: disable DMAR for g4x integrated gfx
Message-ID: <20130203201418.GA2806@kroah.com>
References: <20130203144652.191455164@decadent.org.uk>
 <510E8F30.8070300@ionic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510E8F30.8070300@ionic.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 05:24:16PM +0100, Mihai Moldovan wrote:
> * On 03.02.2013 03:48 PM, Ben Hutchings wrote:
> > [...]
> > +static void quirk_iommu_g4x_gfx(struct pci_dev *dev)
> > +{
> Shouldn't __devinit be used here too, like for quirk_iommu_rwbf?
> 
> It probably doesn't matter too much. especially on platforms with Intel IOMMU,
> but... it makes the code coherent.

__devinit doesn't do anything on 99% of systems, that's why it is now
gone in 3.8, so no need to keep on adding it to old kernels either.

thanks,

greg k-h
