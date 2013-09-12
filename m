Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3ILXHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:07:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab3ILXHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:07:32 -0400
Date: Thu, 12 Sep 2013 16:07:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/46] 3.10.12-stable review
Message-ID: <20130912230731.GB5565@kroah.com>
References: <20130912175721.001906199@linuxfoundation.org>
 <5232419D.1020403@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5232419D.1020403@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 03:35:09PM -0700, Guenter Roeck wrote:
> On 09/12/2013 10:58 AM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.12 release.
> >There are 46 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sat Sep 14 17:56:26 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.12-rc1.gz
> >and the diffstat can be found below.
> >
> 
> Build results:
> 	total: 110 pass: 110 skipped: 0 fail: 0
> 
> Added cris32 and several arm targets since last time. Still no failures.

That's great to see, thanks for testing and letting me know.

greg k-h
