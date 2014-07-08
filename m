Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaGHWKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:10:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaGHWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:10:52 -0400
Date: Tue, 8 Jul 2014 15:15:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/53] 3.10.48-stable review
Message-ID: <20140708221517.GD29964@kroah.com>
References: <20140707235829.281783607@linuxfoundation.org>
 <53BBEFE9.7030508@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BBEFE9.7030508@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 06:19:37AM -0700, Guenter Roeck wrote:
> On 07/07/2014 04:57 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.48 release.
> >There are 53 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Wed Jul  9 23:58:20 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 138 pass: 137 fail: 1
> Failed builds:
> 	score:defconfig
> 
> Qemu tests all passed.
> 
> This is an improvement over 3.10.47, as the unicore32 build now passes.

Yeah!

> Details are available at http://server.roeck-us.net:8010/builders.
> 
> The following patches would fix the remaining build failure.
> 
> ae49b83dca score: normalize global variables exported by vmlinux.lds
> 1ed62ca648 Score: Implement the function csum_ipv6_magic
> 5fbbf8a1a9 Score: The commit is for compiling successfully
> df9e4d1c39 Score: Modify the Makefile of Score, remove -mlong-calls for compiling

Ok, will do that for the next stable release, thanks.

greg k-h
