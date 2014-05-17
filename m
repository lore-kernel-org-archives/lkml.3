Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030364AbaEQRVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:21:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030196AbaEQRVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:21:43 -0400
Date: Sat, 17 May 2014 10:25:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 0/9] 3.4.91-stable review
Message-ID: <20140517172504.GA25935@kroah.com>
References: <20140516225458.512693003@linuxfoundation.org>
 <537783ED.3070900@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537783ED.3070900@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 08:44:45AM -0700, Guenter Roeck wrote:
> On 05/16/2014 03:55 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.4.91 release.
> >There are 9 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sun May 18 22:54:50 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 134 pass: 109 skipped: 18 fail: 7
> 
> Qemu tests all passed.
> 
> There are two new build failures, powerpc:ppc64e_defconfig and powerpc:chroma_defconfig.
> Those are not due to source code changes, but due to added builds.
> Failures are seen if the images are built with binutils 2.24, and are caused by a
> changed assembler ABI. A patch to fix the problem has been submitted but is not yet
> upstream.
> 
> Detailed results are available at http://server.roeck-us.net:8010/builders.
> powerpc builds with binutils 2.24 are shown as 'powerpc_24' architecture.

Thanks for testing and letting me know.

greg k-h
