Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab3LGXSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 18:18:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3LGXR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 18:17:57 -0500
Date: Sat, 7 Dec 2013 15:17:56 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.12 00/83] 3.12.4-stable review
Message-ID: <20131207231756.GA28915@kroah.com>
References: <20131206214640.002320724@linuxfoundation.org>
 <52A39DF5.2060803@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A39DF5.2060803@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 03:15:17PM -0700, Shuah Khan wrote:
> On 12/06/2013 02:50 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.12.4 release.
> >There are 83 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sun Dec  8 21:44:41 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.4-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> 
> patch applied cleanly.
> Compile testing - passed
> Boot testing - passed
> dmesg regression testing - passed
> dmesgs look good. No regressions compared to the previous dmesgs for
> this release. dmesg emerg, crit, alert, err are clean. No
> regressions in warn.

Thanks for testing all three of these -rc releases.

greg k-h
