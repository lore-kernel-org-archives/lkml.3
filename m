Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab3LGRAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 12:00:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3LGRAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 12:00:53 -0500
Date: Sat, 7 Dec 2013 09:02:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/32] 3.4.73-stable review
Message-ID: <20131207170222.GD18638@kroah.com>
References: <20131206214956.830407026@linuxfoundation.org>
 <52A2C3EC.8090009@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A2C3EC.8090009@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 10:45:00PM -0800, Guenter Roeck wrote:
> On 12/06/2013 01:52 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.73 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Dec  8 21:49:13 UTC 2013.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 103 pass: 89 skipped: 10 fail: 4
> 
> qemu tests all passed.
> 
> Results are as expected.
> Details are available as usual at http://server.roeck-us.net:8010/builders.

Thanks for testing and letting me know.

greg k-h
