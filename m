Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3H0WZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 18:25:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab3H0WZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:25:24 -0400
Date: Tue, 27 Aug 2013 15:27:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/74] 3.10.10-stable review
Message-ID: <20130827222743.GB27592@kroah.com>
References: <20130827010424.535365435@linuxfoundation.org>
 <521D0F16.3020301@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521D0F16.3020301@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 02:41:58PM -0600, Shuah Khan wrote:
> On 08/26/2013 07:07 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.10 release.
> > There are 74 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Aug 29 01:03:56 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.10-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> 3.10.10
> --------
> 3.10.10-rc1 applied cleanly to 3.10.9
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> dmesgs look good. No regressions compared to the previous dmesgs for 
> this release. dmesg emerg, crit, alert, err are clean. No regressions in 
> warn.

Great, thanks for testing and letting me know.

greg k-h
