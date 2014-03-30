Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaC3Crx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 22:47:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaC3Cr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 22:47:29 -0400
Date: Sat, 29 Mar 2014 19:49:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 00/46] 3.13.8-stable review
Message-ID: <20140330024928.GA16258@kroah.com>
References: <20140328173134.630198216@linuxfoundation.org>
 <5337728A.5050609@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5337728A.5050609@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 07:25:30PM -0600, Shuah Khan wrote:
> On 03/28/2014 11:31 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.13.8 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Mar 30 17:31:14 UTC 2014.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.8-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Compiled, and booted on my test systems. No regressions in dmesg.

Thanks for testing all 3 of these and letting me know.

greg k-h
