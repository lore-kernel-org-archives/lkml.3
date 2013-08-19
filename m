Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab3HSXLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:11:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3HSXLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:11:07 -0400
Date: Mon, 19 Aug 2013 16:11:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [ 00/45] 3.10.8-stable review
Message-ID: <20130819231106.GB5685@kroah.com>
References: <20130818203620.996166594@linuxfoundation.org>
 <5212A0A8.6070807@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5212A0A8.6070807@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 04:48:08PM -0600, Shuah Khan wrote:
> On 08/18/2013 02:35 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.8 release.
> >There are 45 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Tue Aug 20 20:36:09 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.8-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> 3.10.8-rc1 applied cleanly to 3.10.7.
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> dmesgs look good. No regressions compared to the previous dmesgs for
> each of this release. dmesg emerg, crit, alert, err are clean. No
> regressions in warn.

Thanks for testing and letting me know.

greg k-h
