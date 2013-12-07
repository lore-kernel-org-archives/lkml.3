Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3LGRAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 12:00:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3LGRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 12:00:09 -0500
Date: Sat, 7 Dec 2013 09:01:38 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/58] 3.10.23-stable review
Message-ID: <20131207170138.GC18638@kroah.com>
References: <20131206214844.906193530@linuxfoundation.org>
 <52A2C3A7.5000900@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A2C3A7.5000900@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 10:43:51PM -0800, Guenter Roeck wrote:
> On 12/06/2013 01:51 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.23 release.
> > There are 58 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Dec  8 21:47:53 UTC 2013.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 110 pass: 109 skipped: 0 fail: 1
> 
> Build avr32:atngw100mkii_evklcd101_defconfig still fails.

Hopefully one of the avr32 people will fix it, if they care about
3.10...

> qemu tests all passed.
> 
> Results are as expected.
> Details are available as usual at http://server.roeck-us.net:8010/builders.

Thanks for letting me know.

greg k-h
