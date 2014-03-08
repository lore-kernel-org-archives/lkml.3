Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaCHQSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 11:18:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaCHQSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 11:18:05 -0500
Date: Sat, 8 Mar 2014 08:18:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/99] 3.4.83-stable review
Message-ID: <20140308161839.GA26012@kroah.com>
References: <20140308010611.468206150@linuxfoundation.org>
 <87a9d1nhrk.wl%satoru.takeuchi@gmail.com>
 <531B2AC8.1050205@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531B2AC8.1050205@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 06:35:52AM -0800, Guenter Roeck wrote:
> On 03/08/2014 01:47 AM, Satoru Takeuchi wrote:
> > At Fri,  7 Mar 2014 17:06:56 -0800,
> > Greg Kroah-Hartman wrote:
> >>
> >> This is the start of the stable review cycle for the 3.4.83 release.
> >> There are 99 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Mon Mar 10 01:05:53 UTC 2014.
> >> Anything received after that time might be too late.
> >
> > This kernel passed my test.
> >
> 
> Same here.
> 
> Built results:
> 	total: 119 pass: 97 skipped: 18 fail: 4
> 
> qemu tests all passed.
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks to both of you for testing this, much appreciated.

greg k-h
