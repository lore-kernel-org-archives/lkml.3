Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935057AbaEaBJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:09:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbaEaBIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:08:54 -0400
Date: Fri, 30 May 2014 16:20:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/86] 3.10.41-stable review
Message-ID: <20140530232036.GB25854@kroah.com>
References: <20140529043513.451722422@linuxfoundation.org>
 <538744FD.4080709@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538744FD.4080709@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 07:32:29AM -0700, Guenter Roeck wrote:
> On 05/28/2014 09:36 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.41 release.
> >There are 86 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sat May 31 04:34:49 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 143 pass: 134 skipped: 6 fail: 3
> 
> Qemu tests all passed.
> 
> For reference, failing builds are
> 
> unicore32:defconfig		- still fails for all releases
> powerpc:ppc64e_defconfig	- fail if built with binutils 2.4; patch pending
> powerpc:chroma_defconfig	- fail if built with binutils 2.4; patch pending
> 
> Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing.

greg k-h
