Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbaGHWKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:10:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaGHWKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:10:20 -0400
Date: Tue, 8 Jul 2014 15:14:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/44] 3.4.98-stable review
Message-ID: <20140708221444.GB29964@kroah.com>
References: <20140707235858.652771077@linuxfoundation.org>
 <53BBEE9D.4020900@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BBEE9D.4020900@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 06:14:05AM -0700, Guenter Roeck wrote:
> On 07/07/2014 05:06 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.4.98 release.
> >There are 44 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Wed Jul  9 23:58:50 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 117 pass: 111 fail: 6
> Failed builds:
> 	alpha:allmodconfig
> 	arm:spear6xx_defconfig
> 	score:defconfig
> 	sparc64:allmodconfig
> 	unicore32:defconfig
> 	xtensa:allmodconfig
> 
> Qemu tests all passed.
> 
> Results are as expected.
> 
> Details are available at http://server.roeck-us.net:8010/builders.
> 
> Note that git describe says v3.4.97-46, so the tested version includes
> two more patches than announced.

Thanks for grabbing those two more and testing them.

greg k-h
