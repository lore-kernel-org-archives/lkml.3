Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3LCDDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:03:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3LCDDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:03:33 -0500
Date: Mon, 2 Dec 2013 19:04:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/212] 3.12.3-stable review
Message-ID: <20131203030434.GB26355@kroah.com>
References: <20131202191248.517975703@linuxfoundation.org>
 <20131203024629.GA21479@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203024629.GA21479@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 06:46:29PM -0800, Guenter Roeck wrote:
> On Mon, Dec 02, 2013 at 11:13:11AM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.12.3 release.
> > There are 212 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed Dec  4 19:11:18 UTC 2013.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 110 pass: 107 skipped: 3 fail: 0
> 
> qemu tests all passed. Perfect results.

Thanks for testing and letting me know.

greg k-h
