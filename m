Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaF1Web (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 18:34:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaF1Wea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 18:34:30 -0400
Date: Sat, 28 Jun 2014 15:34:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/43] 3.4.96-stable review
Message-ID: <20140628223417.GA31753@kroah.com>
References: <20140628174449.788784511@linuxfoundation.org>
 <53AF419A.20202@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AF419A.20202@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 03:28:42PM -0700, Guenter Roeck wrote:
> On 06/28/2014 10:45 AM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.4.96 release.
> >There are 43 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Mon Jun 30 17:44:34 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 137 pass: 111 skipped: 20 fail: 6
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
> Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing and letting me know.

greg k-h
