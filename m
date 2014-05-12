Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbaELUaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:30:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbaELUai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:30:38 -0400
Date: Mon, 12 May 2014 22:30:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/83] 3.14.4-stable review
Message-ID: <20140512203037.GA4562@kroah.com>
References: <20140511191907.024339448@linuxfoundation.org>
 <536FFF16.1010505@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536FFF16.1010505@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 03:52:06PM -0700, Guenter Roeck wrote:
> On 05/11/2014 12:19 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.14.4 release.
> > There are 83 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue May 13 19:18:44 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
>      total: 127 pass: 121 skipped: 4 fail: 2
> 
> Failing builds are powerpc:allmodconfig and unicore32:defconfig.
> 
> Qemu tests all passed.
> 
> Results are as expected.
> 
> Details are available at http://server.roeck-us.net:8010/builders.
> 

Thanks for testing all 3 of these and letting me know.

greg k-h
