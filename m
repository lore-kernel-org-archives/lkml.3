Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3LSGel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 01:34:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3LSGej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:34:39 -0500
Date: Wed, 18 Dec 2013 22:34:41 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/118] 3.12.6-stable review
Message-ID: <20131219063441.GA18820@kroah.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131219032745.GA29603@kroah.com>
 <52B28F73.7080800@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B28F73.7080800@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 10:17:23PM -0800, Guenter Roeck wrote:
> On 12/18/2013 07:27 PM, Greg Kroah-Hartman wrote:
> > On Wed, Dec 18, 2013 at 01:10:37PM -0800, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 3.12.6 release.
> >> There are 118 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Fri Dec 20 21:12:03 UTC 2013.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.6-rc1.gz
> >> and the diffstat can be found below.
> >
> > Thanks to a bug on my part, there's now a -rc2 out for people to test
> > with:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.6-rc2.gz
> >
> > Note, if you didn't have a build-failure with -rc1 then no need to test
> > -rc2, it's only a specific staging driver that had an issue.
> >
> 
> Build results are much better:
> 	total: 110 pass: 107 skipped: 3 fail: 0
> 
> qemu tests still all pass.

Wonderful, thanks for testing and letting me know.

greg k-h
