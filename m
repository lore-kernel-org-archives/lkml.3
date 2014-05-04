Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaEDQJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:09:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbaEDQJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 12:09:35 -0400
Date: Sun, 4 May 2014 12:09:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/43] 3.4.89-stable review
Message-ID: <20140504160934.GA11352@kroah.com>
References: <20140504154224.211508175@linuxfoundation.org>
 <536662F8.6060402@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536662F8.6060402@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 08:55:36AM -0700, Guenter Roeck wrote:
> On 05/04/2014 08:41 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.89 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue May  6 15:42:07 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 120 pass: 97 skipped: 18 fail: 5
> 
> Qemu tests all passed.
> 
> There is one new failure, unicore32:defconfig. This is a new build target
> which fails for all releases in my tests, so the failure is undesirable
> but not surprising. Overall results are as expected.
> 
> Details are at http://server.roeck-us.net:8010/builders.

Great, thanks for testing.

greg k-h
