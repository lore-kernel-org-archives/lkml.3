Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbbA1UWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:22:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbbA1UWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:22:20 -0500
Date: Wed, 28 Jan 2015 09:55:02 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.18 00/61] 3.18.5-stable review
Message-ID: <20150128175502.GC28561@kroah.com>
References: <20150128012636.936333725@linuxfoundation.org>
 <54C8EF0B.8000904@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C8EF0B.8000904@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 06:15:39AM -0800, Guenter Roeck wrote:
> On 01/27/2015 05:26 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.18.5 release.
> >There are 61 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Fri Jan 30 01:26:13 UTC 2015.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 134 pass: 134 fail: 0
> Qemu tests:
> 	total: 30 pass: 30 fail: 0
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing all 3 of these and letting me know.

greg k-h
