Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3I3BvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:51:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3I3BvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:51:17 -0400
Date: Sun, 29 Sep 2013 18:51:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/71] 3.11.3-stable review
Message-ID: <20130930015119.GD13344@kroah.com>
References: <20130929192643.539596256@linuxfoundation.org>
 <5248D3D3.50904@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5248D3D3.50904@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 06:28:51PM -0700, Guenter Roeck wrote:
> On 09/29/2013 12:27 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.11.3 release.
> > There are 71 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue Oct  1 19:26:27 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.3-rc1.gz
> > and the diffstat can be found below.
> >
> 
> Build test results:
> 	total: 110 pass: 108 skipped: 2 fail: 0
> 
> Same as with 3.11.2.

Thanks for testing.  Any chance we can ever get those two skipped ones
fixed.  It feels odd that 3.10 passes those and 3.11 doesn't

thanks,

greg k-h
