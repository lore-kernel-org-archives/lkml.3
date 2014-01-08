Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbaAHOSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:18:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524AbaAHOSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:18:04 -0500
Date: Wed, 8 Jan 2014 06:18:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: shuah.kh@samsung.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.12 000/144] 3.12.7-stable review
Message-ID: <20140108141823.GA14758@kroah.com>
References: <20140106223745.326293132@linuxfoundation.org>
 <52CC5062.3080708@samsung.com>
 <20140107191639.GA2825@kroah.com>
 <52CC78EC.3000806@samsung.com>
 <52CD5905.7030203@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CD5905.7030203@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 05:56:21AM -0800, Guenter Roeck wrote:
> On 01/07/2014 02:00 PM, Shuah Khan wrote:
> > On 01/07/2014 12:16 PM, Greg Kroah-Hartman wrote:
> >> On Tue, Jan 07, 2014 at 12:07:14PM -0700, Shuah Khan wrote:
> >>> On 01/06/2014 03:36 PM, Greg Kroah-Hartman wrote:
> >>>> This is the start of the stable review cycle for the 3.12.7 release.
> >>>> There are 144 patches in this series, all will be posted as a response
> >>>> to this one.  If anyone has any issues with these being applied, please
> >>>> let me know.
> >>>>
> >>>> Responses should be made by Wed Jan  8 22:37:25 UTC 2014.
> >>>> Anything received after that time might be too late.
> >>>>
> >>>> The whole patch series can be found in one patch at:
> >>>>     kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.7-rc1.gz
> >>>> and the diffstat can be found below.
> >>>>
> >>>> thanks,
> >>>>
> >>>> greg k-h
> >>>
> >>> Patches testing - passed
> >>> Compile testing - passed
> >>> Boot testing - passed
> >>> dmesg regression testing - passed
> >>>
> >>> Test systems
> >>>
> >>>      Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
> >>>      HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> >>>      Dell OptiPlex 790 Intel(R) Core(TM) i5-2400
> >>>
> >>> Detailed test status
> >>>
> >>> Patches applied cleanly
> >>> dmesgs look good. No regressions compared to the previous dmesgs for this
> >>> release. dmesg emerg, crit, alert, err are clean. No regressions in warn.
> >>
> >> Just in time for me to do a -rc2 release for this, and the 3.10 -rc1
> >> announcement, sorry :)
> >>
> >
> > 3.10.26-rc2 and 3.12.7-rc2 are looking good on all my 3 test systems. No dmesg regressions.
> >
> Same here.

Great, thanks to both of you for testing and letting me know.

greg k-h
