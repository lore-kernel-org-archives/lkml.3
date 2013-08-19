Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab3HSXKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:10:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3HSXKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:10:43 -0400
Date: Mon, 19 Aug 2013 16:10:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [ 00/12] 3.0.92-stable review
Message-ID: <20130819231042.GA5685@kroah.com>
References: <20130818202949.875887601@linuxfoundation.org>
 <5212A202.3070708@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5212A202.3070708@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 04:53:54PM -0600, Shuah Khan wrote:
> On 08/18/2013 02:30 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.0.92 release.
> >There are 12 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Tue Aug 20 20:29:24 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.92-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> 3.0.92-rc1 applied cleanly to 3.0.91.
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> dmesgs look good. No regressions compared to the previous dmesgs for
> this release. dmesg emerg, crit, alert, err are clean. No
> regressions in warn.

Thanks for letting me know.

greg k-h
