Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997Ab3FSWwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:52:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896Ab3FSWwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:52:42 -0400
Date: Wed, 19 Jun 2013 15:53:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anders Hammarquist <iko@iko.pp.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] *** SUBJECT HERE ***
Message-ID: <20130619225315.GB12282@kroah.com>
References: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you forgot a Subject :)

On Wed, Jun 19, 2013 at 02:05:07AM +0200, Anders Hammarquist wrote:
> The USB cable to read out data from the Abbott FreeStyle Precision
> meters, known as the Abbott stip port cable, uses the TI 3410 chip,
> just as the already added stereo port cable. They are essestially
> the same cable, just with different connectors at the end.
> 
> This patch set adds the product id to the driver, and makes the
> product type more explicit. Arguably, the ABBOTT_PRODUCT_ID
> define could be removed, but I left it on the off chance that
> someone other that the TI 3410 driver uses it.

No, it doesn't, please fix up that last patch and resend it.

thanks,

greg k-h
