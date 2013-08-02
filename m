Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3HBWFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:05:25 -0400
Received: from 1wt.eu ([62.212.114.60]:33854 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab3HBWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:05:24 -0400
Date: Sat, 3 Aug 2013 00:05:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/99] 3.10.5-stable review
Message-ID: <20130802220513.GA888@1wt.eu>
References: <20130802100225.478715166@linuxfoundation.org> <B8EFE96D1287C24090BAD9D858E15E6175660F@sisaex02sj> <20130802212444.GB11550@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802212444.GB11550@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 05:24:45AM +0800, Greg Kroah-Hartman wrote:
> On Fri, Aug 02, 2013 at 07:57:31PM +0000, Shuah Khan wrote:
> > On 08/02/2013 09:12 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.10.5 release.
> > > There are 99 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun Aug  4 10:00:45 UTC 2013.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.5-rc1.gz
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > 
> > Patches applied cleanly to 3.0.88, 3.4.55 and 3.10.4
> > 
> > Compiled and booted on the following systems:
> 
> Wonderful, thanks for testing and letting me know.

And just to complete this, it now boots fine on the ARM-based
motherboard that required a patch in 3.10.3, and looks OK on
my laptop which uses the i915 driver.

Cheers,
Willy

