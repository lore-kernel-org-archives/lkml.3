Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3AYUJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:09:51 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:37182 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3AYUJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:09:49 -0500
Date: Fri, 25 Jan 2013 12:09:46 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ian Abbott <abbotti@mev.co.uk>, Mori Hess <fmhess@users.sourceforge.net>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: Move comedi_pci_auto_unconfig to
 drivers.c
Message-ID: <20130125200946.GA27648@kroah.com>
References: <1358894403-26181-1-git-send-email-peterhuewe@gmx.de>
 <1358895810-27115-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358895810-27115-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 12:03:30AM +0100, Peter Huewe wrote:
> Since comedi_pci_auto_unconfig cannot be inlined anymore after
>  staging/comedi: Use comedi_pci_auto_unconfig directly for
>  pci_driver.remove
> is applied, it makes sense to move it drivers.c
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/staging/comedi/comedidev.h |    5 +----
>  drivers/staging/comedi/drivers.c   |    6 ++++++
>  2 files changed, 7 insertions(+), 4 deletions(-)

Thanks, I've taken this one now.

greg k-h
