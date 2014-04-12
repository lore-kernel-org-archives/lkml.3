Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaDLBz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 21:55:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaDLBz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 21:55:56 -0400
Date: Fri, 11 Apr 2014 18:58:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/23] 3.14.1-stable review
Message-ID: <20140412015844.GB6479@kroah.com>
References: <20140411161200.236939691@linuxfoundation.org>
 <53486376.9020604@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53486376.9020604@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 02:49:42PM -0700, Guenter Roeck wrote:
> On 04/11/2014 09:11 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.14.1 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Apr 13 16:11:46 UTC 2014.
> > Anything received after that time might be too late.
> 
> Build results:
>      total: 126 pass: 121 skipped: 4 fail: 1
> 
> Failing build is powerpc:allmodconfig. Error log:
> 
> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> arch/powerpc/kernel/exceptions-64s.S:1312: Error: attempt to move .org backwards
> make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
> 
> Qemu tests all passed. Results match the build results from 3.14, and are
> therefore as expected.
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing all 3 of these and letting me know.

greg k-h
