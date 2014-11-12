Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaKLHeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:34:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaKLHd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:33:59 -0500
Date: Wed, 12 Nov 2014 16:29:51 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.17 000/319] 3.17.3-stable review
Message-ID: <20141112072951.GA8242@kroah.com>
References: <20141112010952.553519040@linuxfoundation.org>
 <5462FD63.5090904@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5462FD63.5090904@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 10:25:39PM -0800, Guenter Roeck wrote:
> On 11/11/2014 05:12 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.17.3 release.
> >There are 319 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Fri Nov 14 01:07:52 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 133 pass: 132 fail: 1
> Failed builds:
> 	avr32:atngw100mkii_evklcd101_defconfig
> 
> Qemu tests:
> 	total: 30 pass: 30 fail: 0
> 
> The failing build is due to a link error:
> 
> lib/lib.a(vsprintf.o): In function `vsnprintf':
> vsprintf.c:(.text+0x16dc): relocation truncated to fit:
> 	R_AVR32_16N_PCREL against symbol `_ctype' defined in .text section in lib/lib.a(ctype.o)
> 
> which has been observed on and off for the last few releases.
> 
> Details are available at http://server.roeck-us.net:8010/builder.

Thanks for testing, I'll not worry about avr32 as that's an odd one...

greg k-h
