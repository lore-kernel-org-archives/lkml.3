Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3LSDkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 22:40:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3LSDkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 22:40:33 -0500
Date: Wed, 18 Dec 2013 19:40:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/78] 3.10.25-stable review
Message-ID: <20131219034035.GB30168@kroah.com>
References: <20131218211111.903835960@linuxfoundation.org>
 <52B25419.9000807@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B25419.9000807@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 06:04:09PM -0800, Guenter Roeck wrote:
> On 12/18/2013 01:10 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.25 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri Dec 20 21:10:56 UTC 2013.
> > Anything received after that time might be too late.
> >
> 
> Build results:
>      total: 110 pass: 109 skipped: 0 fail: 1
> 
> Build avr32:atngw100mkii_evklcd101_defconfig still fails.
> 
> qemu tests all passed.
> 
> Results are as expected.
> Details are available as usual at http://server.roeck-us.net:8010/builders.

Thanks for testing and letting me know.

greg k-h
