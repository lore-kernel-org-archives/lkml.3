Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaJ3FiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 01:38:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51374 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaJ3FiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 01:38:07 -0400
Date: Thu, 30 Oct 2014 11:07:56 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192e: from bus specific dma api to dma api
Message-ID: <20141030053756.GA3519@sudip-PC>
References: <1413968086-15451-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20141029084725.GB18675@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029084725.GB18675@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:47:25PM +0800, Greg Kroah-Hartman wrote:
> On Wed, Oct 22, 2014 at 02:24:46PM +0530, Sudip Mukherjee wrote:
> > we should be using DMA API rather than using bus specific DMA API.
> 
> Why?
> 

as given in the DMA-API-HOWTO.txt : 
the DMA API works with any bus independent of the underlying
microprocessor architecture.

> > converted the occurrence of pci_map_*() to dma_map_*(),
> > and at the same time used the dma_mapping_error().	  
> 
> Trailing whitespace :(
> 
oops .. really sorry . when i checked with checkpatch it didnot show any error.
and I did not know that trailing whitespaces should not be there in the
commit message also.

> What have you used to test this change?

it has just been build tested , not tested on hardware.

thanks
sudip
> 
> thanks,
> 
> greg k-h
