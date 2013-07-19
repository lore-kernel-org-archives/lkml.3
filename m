Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3GSXtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:49:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3GSXtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:49:39 -0400
Date: Fri, 19 Jul 2013 16:44:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/72] 3.10.2-stable review
Message-ID: <20130719234448.GA3264@kroah.com>
References: <20130719052559.852627424@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E6174690B@sisaex01sj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6174690B@sisaex01sj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 11:16:47PM +0000, Shuah Khan wrote:
> On 07/19/2013 09:32 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.2 release.
> > There are 72 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Jul 21 05:25:08 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.2-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Patches applied cleanly to 3.0.86, 3.4.54, 3.9.10, and 3.10.1
> 
> 3.9.11-rc1 patch failed to build:
> x64-64, mipsel, mips, powerpc, and tile: build failed with the following 
> error:

Thanks for testing and sending the results.  I've fixed the 3.9 build
issue and will push a new patch out in a bit.

greg k-h
