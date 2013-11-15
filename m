Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab3KOCPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 21:15:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3KOCPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 21:15:00 -0500
Date: Fri, 15 Nov 2013 11:09:59 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: rjw@rjwysocki.net, shuahkhan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add Legacy PM OPS usage checks to class, bus, and
 driver register functions
Message-ID: <20131115020959.GA8644@kroah.com>
References: <cover.1383868060.git.shuah.kh@samsung.com>
 <5284EF9F.5050508@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5284EF9F.5050508@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 08:43:27AM -0700, Shuah Khan wrote:
> On 11/07/2013 05:03 PM, Shuah Khan wrote:
> > Add Legacy PM OPS usage checks to class, bus, and driver register functions.
> > If Legacy PM OPS usage is found, print warning message to indicate the driver
> > code needs updating to use Dev PM OPS interfaces. This will help serve as a way
> > to track drivers that still use Legacy PM OPS and fix them.
> >
> > This patch set adds Legacy PM OPS usage check and warning to bus_register(),
> > __class_register(), and driver_register() functions.
> >
> > Individual patches in this series are not dependent on each other. The only
> > reason this is a series is for context and facilitating discussion on the
> > overall change as opposed individual patches.
> >
> > Shuah Khan (3):
> >    drivers/bus: Add Legacy PM OPS usage check and warning to
> >      bus_register()
> >    drivers/class: Add Legacy PM OPS usage check and warning to
> >      __class_register()
> >    driver: Add Legacy PM OPS usage check and warning to driver_register()
> >
> >   drivers/base/bus.c    | 3 +++
> >   drivers/base/class.c  | 4 ++++
> >   drivers/base/driver.c | 4 ++++
> >   3 files changed, 11 insertions(+)
> >
> 
> Greg/Rafael,
> 
> Any feedback on this series? Haven't gotten to it or don't like it?

It's the middle of the merge window, where I can't apply any new
patches, and I'm traveling in Korea, so nothing is getting done on any
patches anyone has sent me, you aren't alone :)

Wait until 3.13-rc1 is out, then I'll start digging through my patch
queue and reviewing them, your's is in there as well.

thanks,

greg k-h
