Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3EGT0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 15:26:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3EGT0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 15:26:23 -0400
Date: Tue, 7 May 2013 12:26:22 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [ 00/46] 3.0.77-stable review
Message-ID: <20130507192622.GA5700@kroah.com>
References: <20130506225820.628893970@linuxfoundation.org>
 <CAKocOOM7rXbFbD73ZZ2zmS6SGgaytmWd-36uV+G2OVO88Zb=Og@mail.gmail.com>
 <1367954088.7469.10.camel@lorien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367954088.7469.10.camel@lorien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 07:14:48PM +0000, Shuah Khan wrote:
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Date: Mon, May 6, 2013 at 4:58 PM
> > Subject: [ 00/46] 3.0.77-stable review
> > To: linux-kernel@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
> > torvalds@linux-foundation.org, akpm@linux-foundation.org,
> > stable@vger.kernel.org
> > 
> > 
> > This is the start of the stable review cycle for the 3.0.77 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed May  8 22:56:20 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.77-rc1.gz
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> Patches applied cleanly to 3.0.76, 3.4.43, 3.8.11, and 3.9.0 
> 
> Compiled and booted on the following systems:

Thanks for testing all of these and letting us know.

greg k-h
