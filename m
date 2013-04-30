Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3D3CCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:02:22 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:45185 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab3D3CCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:02:20 -0400
Date: Mon, 29 Apr 2013 19:02:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [ 00/42] 3.8.11-stable review
Message-ID: <20130430020217.GA5858@kroah.com>
References: <20130429184752.435249613@linuxfoundation.org>
 <1367286877.14116.3.camel@lorien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367286877.14116.3.camel@lorien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 01:54:37AM +0000, Shuah Khan wrote:
> On Mon, 2013-04-29 at 12:01 -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.8.11 release.
> > There are 42 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed May  1 18:47:07 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.11-rc1.gz
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Patches applied cleanly to 3.0.75, 3.4.42, and 3.8.10 
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 Intel Corei5 (3.4.43-rc1 and 3.8.11-rc1)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> dmesgs for all releases look good. No regressions compared to the
> previous dmesgs for each of these releases.

Great, thanks for testing and letting us know.

greg k-h
