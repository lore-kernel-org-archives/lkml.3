Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3KLHgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:36:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3KLHgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:36:44 -0500
Date: Mon, 11 Nov 2013 14:51:05 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/26] 3.4.69-stable review
Message-ID: <20131111225105.GB22449@kroah.com>
References: <20131109065050.089866597@linuxfoundation.org>
 <52811AC8.4060804@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52811AC8.4060804@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 10:58:32AM -0700, Shuah Khan wrote:
> On 11/08/2013 11:51 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.69 release.
> > There are 26 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Mon Nov 11 06:50:22 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.69-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> 3.4.69
> 
> Patch applied cleanly    yes
> Compile test        passed
> Boot test        passed
> dmesg regression test    passed
> 
> dmesgs look good. No regressions compared to the previous dmesgs for 
> this release. dmesg emerg, crit, alert, err are clean. No regressions in 
> warn.

Thanks for testing and letting me know.

greg k-h
