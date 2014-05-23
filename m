Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaEWSnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:43:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaEWSnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:43:32 -0400
Date: Fri, 23 May 2014 21:17:22 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: ii_pci20kc: fix usage of uninit scalar
 in ii20k_attach()
Message-ID: <20140523121722.GA31526@kroah.com>
References: <20140504022609.7b1ba9c1@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140504022609.7b1ba9c1@spike>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 02:26:09AM +0200, Christian Engelmayer wrote:
> This driver supports the PCI-20001C-1a and PCI-20001C-2a carrier boards.
> The -2a version has 32 on-board DIO channels. In case this variant is
> detected, local variable 'has_dio' is set accordingly. Otherwise it is
> left uninitialized and the following subdevice instantiation depends on
> the stack. Detected by Coverity - CID 1077830.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
> ---
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

It doesn't apply there at all for some odd reason, can you refresh it
and resend?

thanks,

greg k-h
