Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3IZQD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:03:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab3IZQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:03:26 -0400
Date: Thu, 26 Sep 2013 09:03:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Mack <zonque@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 0/4] dac7512: some cleanups and DT bindings
Message-ID: <20130926160325.GA10154@kroah.com>
References: <1379879509-3608-1-git-send-email-zonque@gmail.com>
 <20130923101940.GZ21013@sirena.org.uk>
 <52401884.2070509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52401884.2070509@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 12:31:32PM +0200, Daniel Mack wrote:
> On 23.09.2013 12:19, Mark Brown wrote:
> > On Sun, Sep 22, 2013 at 09:51:45PM +0200, Daniel Mack wrote:
> >> Here are some trivial things for the ti_dac7512 driver.
> >>
> >> Mark, can you take them through your spi tree?
> > 
> > I can but it's normally Greg who looks after drivers/misc - probably
> > best to at least run these by him.
> 
> Alright. Greg, I posted the series to LKML yesterday. Can you pick the
> patches from there or do you want me to resend?

I've got them and will take them through my tree, thanks.

greg k-h
