Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbaCFEpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:45:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaCFEpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:45:43 -0500
Date: Wed, 5 Mar 2014 20:46:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13 000/172] 3.13.6-stable review
Message-ID: <20140306044609.GB6466@kroah.com>
References: <20140304200259.626667112@linuxfoundation.org>
 <5317A59D.4060201@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5317A59D.4060201@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 03:30:53PM -0700, Shuah Khan wrote:
> On 03/04/2014 01:01 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.13.6 release.
> > There are 172 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Mar  6 20:02:29 UTC 2014.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.6-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Compile tests and boot tests passed. No dmesg regressions: emerg, crit, 
> alert, err are clean. No regressions in warn.

Thanks for testing both of these.

greg k-h
