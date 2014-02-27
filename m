Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaB0DcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:32:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaB0DcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:32:07 -0500
Date: Wed, 26 Feb 2014 19:35:14 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Johannes Thumshirn <johannes.thumshirn@men.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] iio: adc: Add MEN 16z188 ADC driver
Message-ID: <20140227033514.GB31199@kroah.com>
References: <1393432147-31355-1-git-send-email-johannes.thumshirn@men.de>
 <1393432147-31355-4-git-send-email-johannes.thumshirn@men.de>
 <b6961624-add3-480a-8757-c2ff2893622f@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6961624-add3-480a-8757-c2ff2893622f@email.android.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 05:20:03PM +0000, Jonathan Cameron wrote:
> 
> 
> On February 26, 2014 4:29:07 PM GMT+00:00, Johannes Thumshirn <johannes.thumshirn@men.de> wrote:
> >Add support for MEN 16z188 ADC IP Core on MCB FPGAs.
> >
> >Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> Acked-by: Jonathan Cameron <jic23@kernel.org>
> 
> The other two patches look sane to me as well.
> 
> Anyhow, assuming everyone is happy with those (not yet clear)... Greg do you want to
>  take this directly or would you prefer if I pick the series up and send on to you via the IIO
>  tree? I'm happy either way.

I can take it directly, no need for you to queue it up.

thanks,

greg k-h
