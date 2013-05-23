Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492Ab3EWQ5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:57:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3EWQ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:57:50 -0400
Date: Thu, 23 May 2013 09:57:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/21] 3.9.4-stable review
Message-ID: <20130523165748.GD18598@kroah.com>
References: <20130522205232.597066680@linuxfoundation.org>
 <1369327968.5427.1.camel@lorien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369327968.5427.1.camel@lorien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 04:52:48PM +0000, Shuah Khan wrote:
> On Wed, 2013-05-22 at 15:10 -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.9.4 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri May 24 20:50:18 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.4-rc1.gz
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Patches applied cleanly to 3.0.79, 3.4.46, and 3.9.3
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5:
>     (3.4.47-rc1, and 3.9.4-rc1)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
>     (3.0.80-rc1, 3.4.47-rc1, and 3.9.4-rc1)
> 
> dmesgs for all releases look good. No regressions compared to the previous
> dmesgs for each of these releases.

Great, thanks for testing and letting us know.

greg k-h
