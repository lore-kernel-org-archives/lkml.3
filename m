Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbaGQVMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:12:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaGQVMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:12:05 -0400
Date: Thu, 17 Jul 2014 13:58:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: question regarding drivers/staging/iio/adc/ad7280a.c
Message-ID: <20140717205815.GB1532@kroah.com>
References: <CAB78YHwneVuVBPujeKE=rEygvtyn=VvtLtd75+pvwqxPxYcB6g@mail.gmail.com>
 <53C5656F.9030200@kernel.org>
 <53C65E8F.2080708@metafoo.de>
 <CAB78YHzEPZf-8m0zwFz5PZWkqMuX9m5W01f2JGQ+7MbAkTACPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB78YHzEPZf-8m0zwFz5PZWkqMuX9m5W01f2JGQ+7MbAkTACPg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 11:40:04PM +0530, Himangi Saraogi wrote:
> Hi,
> 
> I have sent in a patch for adding devm_kasprintf https://lkml.org/lkml/2014/7/
> 16/667.
> I will be updating this file and send in a patch once it is accepted. Was it
> the right thing
> to do to send the devm_kasprintf patch separately from the patch on the file to
> use it for,
> because the person applying the later may not see the dependency?

Well, you should have told me there was a dependancy :)

As I'll end up taking both of these patches in the end, I'll queue your
devm_kasprintf patch up in my staging-next tree so that it will work
properly with your patch.

thanks,

greg k-h
