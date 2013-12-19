Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3LSDkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 22:40:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3LSDkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 22:40:21 -0500
Date: Wed, 18 Dec 2013 19:40:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/31] 3.4.75-stable review
Message-ID: <20131219034023.GA30168@kroah.com>
References: <20131218210522.790152625@linuxfoundation.org>
 <52B253C5.3030201@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B253C5.3030201@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 06:02:45PM -0800, Guenter Roeck wrote:
> On 12/18/2013 01:08 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.75 release.
> > There are 31 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri Dec 20 21:05:11 UTC 2013.
> > Anything received after that time might be too late.
> >
> Build results:
>      total: 103 pass: 89 skipped: 10 fail: 4
> 
> qemu tests all passed.
> 
> Results are as expected.
> Details are available as usual at http://server.roeck-us.net:8010/builders.

Thanks for testing.

greg k-h
