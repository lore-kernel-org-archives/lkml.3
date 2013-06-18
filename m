Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab3FRWLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:11:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab3FRWLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:11:15 -0400
Date: Tue, 18 Jun 2013 15:11:14 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/48] 3.9.7-stable review
Message-ID: <20130618221114.GA11055@kroah.com>
References: <20130618161725.912524266@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E6172B0E3@sisaex02sj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6172B0E3@sisaex02sj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 09:55:13PM +0000, Shuah Khan wrote:
> On 06/18/2013 11:24 AM, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > This is the start of the stable review cycle for the 3.9.7 release.
> > There are 48 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Jun 20 16:15:42 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.7-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Patches applied cleanly to 3.0.82, 3.4.49, and 3.9.6
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5:
>      (3.4.50-rc1, and 3.9.7-rc1)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
>      (3.0.83-rc1, 3.4.50-rc1, and 3.9.7-rc1)
> 
> dmesgs for all releases look good. No regressions compared to the 
> previous dmesgs for each of these releases.

Great, thanks for testing and letting me know.

greg k-h
