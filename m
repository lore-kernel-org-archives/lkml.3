Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3KBWIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 18:08:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3KBWIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 18:08:43 -0400
Date: Sat, 2 Nov 2013 15:10:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.11 00/66] 3.11.7-stable review
Message-ID: <20131102221050.GB14960@kroah.com>
References: <20131101220634.605745564@linuxfoundation.org>
 <52756F11.8010401@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52756F11.8010401@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 02, 2013 at 03:30:57PM -0600, Shuah Khan wrote:
> On 11/01/2013 04:06 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.11.7 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Nov  3 22:04:49 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.7-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Release 3.11.7	
> 
> Patch applied cleanly	yes
> Compile test		passed
> Boot test		passed
> dmesg regression test	passed
> Cross-compile test	passed
> 
> Architecture 	Config 		3.11.7
> alpha 		defconfig 	Passed
> arm 		defconfig 	Passed
> arm64 		defconfig 	Passed
> blackfin 	defconfig 	Passed
> c6x 		defconfig 	Passed
> mips 		defconfig 	Passed
> mipsel 		defconfig 	Passed
> powerpc 	wii_defconfig 	Passed
> sh 		defconfig 	Passed
> sparc 		defconfig 	Passed
> tile 		defconfig 	Passed

Thanks for testing all three releases and letting me know it all works
properly.

greg k-h
