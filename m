Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175Ab3LKGv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:51:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3LKGv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:51:57 -0500
Date: Tue, 10 Dec 2013 22:53:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: shuah.kh@samsung.com, shuahkhan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add Legacy PM OPS usage checks to class, bus, and
 driver register functions
Message-ID: <20131211065330.GA25814@kroah.com>
References: <cover.1383868060.git.shuah.kh@samsung.com>
 <5284EF9F.5050508@samsung.com>
 <1786563.y3Kg82Sl7s@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1786563.y3Kg82Sl7s@vostro.rjw.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 10:50:29PM +0100, Rafael J. Wysocki wrote:
> On Thursday, November 14, 2013 08:43:27 AM Shuah Khan wrote:
> > On 11/07/2013 05:03 PM, Shuah Khan wrote:
> > > Add Legacy PM OPS usage checks to class, bus, and driver register functions.
> > > If Legacy PM OPS usage is found, print warning message to indicate the driver
> > > code needs updating to use Dev PM OPS interfaces. This will help serve as a way
> > > to track drivers that still use Legacy PM OPS and fix them.
> > >
> > > This patch set adds Legacy PM OPS usage check and warning to bus_register(),
> > > __class_register(), and driver_register() functions.
> > >
> > > Individual patches in this series are not dependent on each other. The only
> > > reason this is a series is for context and facilitating discussion on the
> > > overall change as opposed individual patches.
> > >
> > > Shuah Khan (3):
> > >    drivers/bus: Add Legacy PM OPS usage check and warning to
> > >      bus_register()
> > >    drivers/class: Add Legacy PM OPS usage check and warning to
> > >      __class_register()
> > >    driver: Add Legacy PM OPS usage check and warning to driver_register()
> > >
> > >   drivers/base/bus.c    | 3 +++
> > >   drivers/base/class.c  | 4 ++++
> > >   drivers/base/driver.c | 4 ++++
> > >   3 files changed, 11 insertions(+)
> > >
> > 
> > Greg/Rafael,
> > 
> > Any feedback on this series? Haven't gotten to it or don't like it?
> 
> I haven't had the time to review this, sorry.

ping?
