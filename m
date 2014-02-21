Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaBUTAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:00:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaBUTAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:00:10 -0500
Date: Fri, 21 Feb 2014 11:01:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/66] 3.10.32-stable review
Message-ID: <20140221190137.GB25991@kroah.com>
References: <20140220234909.482516304@linuxfoundation.org>
 <5306DF9C.5050408@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5306DF9C.5050408@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 09:09:48PM -0800, Guenter Roeck wrote:
> On 02/20/2014 03:50 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.32 release.
> >There are 66 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sat Feb 22 23:48:52 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 126 pass: 111 skipped: 4 fail: 11
> 
> qemu tests all passed. Results are not as expected. New failures are
> due to
> 
> Guenter Roeck <linux@roeck-us.net>
>     iio: max1363: Use devm_regulator_get_optional for optional regulator
> 
> [Oops]

This patch is now dropped, thanks.

greg k-h
