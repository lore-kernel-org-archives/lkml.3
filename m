Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaDNMxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:53:55 -0400
Received: from mail001.aei.ca ([206.123.6.130]:45516 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbaDNMxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:53:53 -0400
From: Ed Tomlinson <edt@aei.ca>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 3.14-rc6 problems with an R7 260X
Date: Mon, 14 Apr 2014 08:53:42 -0400
Message-ID: <1595649.0SZEcoJpxL@grover>
Organization: me
User-Agent: KMail/4.12.4 (Linux/3.15.0-1-git; KDE/4.12.4; x86_64; ; )
In-Reply-To: <1707205.THdbAVLWUB@grover>
References: <1825482.79WA6myBva@grover> <33204379.FfpmvHoDUX@grover> <1707205.THdbAVLWUB@grover>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 March 2014 16:08:37 Ed Tomlinson wrote:
> On Monday 10 March 2014 13:29:41 Ed Tomlinson wrote:
> > On Monday 10 March 2014 12:38:42 Alex Deucher wrote:
> > > On Mon, Mar 10, 2014 at 11:47 AM, Ed Tomlinson <edt@aei.ca> wrote:
> > > > Hi,
> > > >
> > > > I recently added a R7 260X to my system.  While the card works with 3.13 its supposed work much better with 14-rc.
> > > > This is not the case.  My system is unstable without radeon.dpm=0 which was the default in .13.  Here are some extracts
> > > > from the logs of the latest fun with dpm enabled:
> > 
> > omitted
> > 
> > > > The above type of errors repeat hundreds of times and eventually the display freezes (this box does not have a serial console and it did not check with ssh)
> > > >
> > > > When X started I did notice some corruption.  There are sets of two rectangles about of a height of 2 or 3 mm, width of 25m or so with a second
> > > > about a cm below.  The often occurs in chomium especially when scrolling.  Runing the  unigine-sanctuary or unigine-tropics demo/benchmark
> > > > programs also produce the above problems and eventually stall.
> > > >
> > > > The problem is reproducible - I am not that familiar with gpu problems though, what else will help debug this?
> > > >
> > > 
> > > Please file a bug at https://bugs.freedesktop.org (Product: DRI,
> > > Component: DRM/Radeon) and attach your dmesg output and xorg log.
> > 
> > Filed as bug 75992
> > 
> > Let me know if you want me to test anything or if more info is needed.
> 
> This still occurrs with rc7.  With dpm enabled X is not usable.  It stalls, sometimes with nasty screen corruption, after a few minute.  With dpm disabled
> its much better (not perfect though).

This has been solved via a firmware fix and a patch see: https://bugs.freedesktop.org/show_bug.cgi?id=75992

Ed Tomlinson
