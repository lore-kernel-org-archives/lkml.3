Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbaKTPGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:06:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaKTPGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:06:07 -0500
Date: Thu, 20 Nov 2014 07:04:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.17 000/141] 3.17.4-stable review
Message-ID: <20141120150447.GB12354@kroah.com>
References: <20141119205150.700188369@linuxfoundation.org>
 <546D7E4A.8060902@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546D7E4A.8060902@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:38:18PM -0800, Guenter Roeck wrote:
> On 11/19/2014 12:50 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.17.4 release.
> >There are 141 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Fri Nov 21 20:51:28 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 133 pass: 132 fail: 1
> Failed builds:
> 	avr32:atngw100mkii_evklcd101_defconfig	
> 
> Qemu test results:
> 	total: 30 pass: 30 fail: 0
> 
> Details at http://server.roeck-us.net:8010/builders.

Thanks for testing all of these and letting me know.

greg k-h
