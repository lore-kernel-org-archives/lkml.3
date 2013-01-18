Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3ARUop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:44:45 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64369 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3ARUoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:44:44 -0500
Date: Fri, 18 Jan 2013 12:44:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jake Champlin <jake.champlin.27@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        hsweeten@visiongravers.com, wfp5p@virginia.edu,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: addi_acpi_035: Fixed Camel Case Coding
 Style Issue
Message-ID: <20130118204440.GA4788@kroah.com>
References: <20130118034931.GA7126@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118034931.GA7126@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:49:36PM -0500, Jake Champlin wrote:
> Fixed camel case style issue.
> 
> Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
> ---
>  drivers/staging/comedi/drivers/addi_apci_035.c | 34 +++++++++++++-------------
>  1 file changed, 17 insertions(+), 17 deletions(-)

Did you even build the kernel with this patch applied?

I kind of doubt it...

Sorry, we can't accept this.

greg k-h
