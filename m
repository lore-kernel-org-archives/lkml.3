Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab3HSTfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:35:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3HSTfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:35:39 -0400
Date: Mon, 19 Aug 2013 12:35:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [ 00/34] 3.4.59-stable review
Message-ID: <20130819193538.GB24897@kroah.com>
References: <20130818203259.653403173@linuxfoundation.org>
 <52125DA9.3090601@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52125DA9.3090601@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 12:02:17PM -0600, Shuah Khan wrote:
> On 08/18/2013 02:34 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.4.59 release.
> >There are 34 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Note, there are a number of "build fixes" in this round, in the quest to
> >get all arches building properly to be able to track future regressions
> >easier.  Many thanks to Guenter Roeck and Geert Uytterhoeven for their
> >work in doing this.
> >
> >Responses should be made by Tue Aug 20 20:32:48 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.59-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Greg,
> 
> This release is not looking good on one of test systems. Bluetooth
> is not recognized and wireless doesn't work. I am going to start
> bisect and giving you a head-up. The following new dmesg -l crit
> regression messages:

That's odd, given that there are no bluetooth changes in this release.

> CPU2: Package power limit notification (total events = 1)
> CPU3: Package power limit notification (total events = 1)
> CPU0: Package power limit notification (total events = 1)
> CPU1: Package power limit notification (total events = 1)
> 
> and the following traces in dmesg:
> [  124.802169] init: udevtrigger post-stop process (353) terminated
> with status 1
> [  243.439212] INFO: task crda:723 blocked for more than 120 seconds.

What is "crda"?

Any luck with bisection?  It should go fast as the majority of patches
here are non-x86.

thanks,

greg k-h
