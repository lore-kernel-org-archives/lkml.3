Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaBVUmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 15:42:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaBVUmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 15:42:21 -0500
Date: Sat, 22 Feb 2014 12:45:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>, Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/25] 3.4.82-stable review
Message-ID: <20140222204504.GA11373@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5306DEB6.2020205@roeck-us.net>
 <5307E3FF.206@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 04:40:47PM -0700, Shuah Khan wrote:
> Compile tests and boot tests passed. No dmesg regressions: emerg, crit, 
> alert, err are clean. No regressions in warn.

On Thu, Feb 20, 2014 at 09:05:58PM -0800, Guenter Roeck wrote:
> Build results:
> 	total: 119 pass: 97 skipped: 18 fail: 4
> 
> qemu tests all passed. Results are as expected.
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing and letting me know.

greg k-h
