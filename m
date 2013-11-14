Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab3KNViF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:38:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49794 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756160Ab3KNVh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:37:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: shuah.kh@samsung.com
Cc: gregkh@linuxfoundation.org, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add Legacy PM OPS usage checks to class, bus, and driver register functions
Date: Thu, 14 Nov 2013 22:50:29 +0100
Message-ID: <1786563.y3Kg82Sl7s@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5284EF9F.5050508@samsung.com>
References: <cover.1383868060.git.shuah.kh@samsung.com> <5284EF9F.5050508@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 14, 2013 08:43:27 AM Shuah Khan wrote:
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

I haven't had the time to review this, sorry.

Thanks,
Rafael

