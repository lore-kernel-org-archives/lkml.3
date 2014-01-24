Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaAXELT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 23:11:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaAXELS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 23:11:18 -0500
Date: Thu, 23 Jan 2014 20:12:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/23] 3.10.28-stable review
Message-ID: <20140124041210.GE25507@kroah.com>
References: <20140123183859.635713053@linuxfoundation.org>
 <20140123233545.GA32121@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123233545.GA32121@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 03:35:45PM -0800, Guenter Roeck wrote:
> On Thu, Jan 23, 2014 at 10:39:33AM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.28 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat Jan 25 18:38:43 UTC 2014.
> > Anything received after that time might be too late.
> > 
> Build results are as expected:
> 	total: 126 pass: 121 skipped: 4 fail: 1
> 
> The failing build is avr32:atngw100mkii_evklcd101_defconfig.

That means we fixed the previous build errors, which is good to know.  I
guess no one cares about avr32 for this kernel release, which is fine.

thanks,

greg k-h
