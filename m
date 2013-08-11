Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3HKDVM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 23:21:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3HKDVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 23:21:07 -0400
Date: Sat, 10 Aug 2013 20:22:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [ 000/102] 3.10.6-stable review
Message-ID: <20130811032230.GA14919@kroah.com>
References: <20130809015010.208118575@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E61761C23@sisaex02sj>
 <20130809191002.GC10130@kroah.com>
 <B8EFE96D1287C24090BAD9D858E15E61762F0A@sisaex02sj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E61762F0A@sisaex02sj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 10:07:08PM +0000, Shuah Khan wrote:
> On 08/09/2013 01:10 PM, Greg Kroah-Hartman wrote:
> > On Fri, Aug 09, 2013 at 02:42:24PM +0000, Shuah Khan wrote:
> >> On 08/09/2013 07:54 AM, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 3.10.6 release.
> >>> There are 102 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Sun Aug 11 01:46:31 UTC 2013.
> >>> Anything received after that time might be too late.
> >>>
> >>> The whole patch series can be found in one patch at:
> >>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
> >>> and the diffstat can be found below.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>>
> >
> 
> Patches applied to 3.0.89, 3.4.56 and 3.10.5
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5:
>      (3.4.57-rc1, 3.10.6-rc1)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
>      (3.0.90-rc1, 3.4.57-rc1, and 3.10.6-rc1)
> 
> dmesgs for all releases look good. No regressions compared to the 
> previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
> err are clean. No regressions in warn.

Thanks for testing all of these and letting me know.

greg k-h
