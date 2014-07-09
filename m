Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbaGIKWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:22:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36036 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbaGIKWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:22:00 -0400
Date: Wed, 9 Jul 2014 11:21:54 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/53] 3.10.48-stable review
Message-ID: <20140709102154.GC6924@hercules>
References: <20140707235829.281783607@linuxfoundation.org>
 <53BBEFE9.7030508@roeck-us.net>
 <20140708221517.GD29964@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140708221517.GD29964@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 03:15:17PM -0700, Greg Kroah-Hartman wrote:
> On Tue, Jul 08, 2014 at 06:19:37AM -0700, Guenter Roeck wrote:
> > On 07/07/2014 04:57 PM, Greg Kroah-Hartman wrote:
> > >This is the start of the stable review cycle for the 3.10.48 release.
> > >There are 53 patches in this series, all will be posted as a response
> > >to this one.  If anyone has any issues with these being applied, please
> > >let me know.
> > >
> > >Responses should be made by Wed Jul  9 23:58:20 UTC 2014.
> > >Anything received after that time might be too late.
> > >
> > 
> > Build results:
> > 	total: 138 pass: 137 fail: 1
> > Failed builds:
> > 	score:defconfig
> > 
> > Qemu tests all passed.
> > 
> > This is an improvement over 3.10.47, as the unicore32 build now passes.
> 
> Yeah!
> 
> > Details are available at http://server.roeck-us.net:8010/builders.
> > 
> > The following patches would fix the remaining build failure.
> > 
> > ae49b83dca score: normalize global variables exported by vmlinux.lds
> > 1ed62ca648 Score: Implement the function csum_ipv6_magic
> > 5fbbf8a1a9 Score: The commit is for compiling successfully
> > df9e4d1c39 Score: Modify the Makefile of Score, remove -mlong-calls for compiling
> 
> Ok, will do that for the next stable release, thanks.
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'll queue them for the 3.11 kernel as well.  Thanks.

Cheers,
--
Luís
