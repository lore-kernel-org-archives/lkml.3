Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145AbaCWUAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 16:00:32 -0400
Received: from mail001.aei.ca ([206.123.6.130]:51470 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaCWUAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 16:00:31 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [BUG] 3.14-rc6 problems with an R7 260X
Date: Sun, 23 Mar 2014 16:00:23 -0400
Message-ID: <2497696.SigshgMW0H@grover>
Organization: me
User-Agent: KMail/4.12.3 (Linux/3.14.0-1-mainline; KDE/4.12.3; x86_64; ; )
In-Reply-To: <33204379.FfpmvHoDUX@grover>
References: <1825482.79WA6myBva@grover> <CADnq5_Ps61MBXQBSXxetTuyONaU=h0_qtiUaes8XWJwDLCkCVg@mail.gmail.com> <33204379.FfpmvHoDUX@grover>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2014 13:29:41 Ed Tomlinson wrote:
> On Monday 10 March 2014 12:38:42 Alex Deucher wrote:
> > On Mon, Mar 10, 2014 at 11:47 AM, Ed Tomlinson <edt@aei.ca> wrote:
> > > Hi,
> > >
> > > I recently added a R7 260X to my system.  While the card works with 3.13 its supposed work much better with 14-rc.
> > > This is not the case.  My system is unstable without radeon.dpm=0 which was the default in .13.  Here are some extracts
> > > from the logs of the latest fun with dpm enabled:
> 
> omitted
> 
> > > The above type of errors repeat hundreds of times and eventually the display freezes (this box does not have a serial console and it did not check with ssh)
> > >
> > > When X started I did notice some corruption.  There are sets of two rectangles about of a height of 2 or 3 mm, width of 25m or so with a second
> > > about a cm below.  The often occurs in chomium especially when scrolling.  Runing the  unigine-sanctuary or unigine-tropics demo/benchmark
> > > programs also produce the above problems and eventually stall.
> > >
> > > The problem is reproducible - I am not that familiar with gpu problems though, what else will help debug this?
> > >
> > 
> > Please file a bug at https://bugs.freedesktop.org (Product: DRI,
> > Component: DRM/Radeon) and attach your dmesg output and xorg log.
> 
> Filed as bug 75992
> 
> Let me know if you want me to test anything or if more info is needed.

This bug also occurs with rc7.  My system is not useable when booted without radeon.dpm=0 - X stalls after a minute or two of use.

Thanks
Ed Tomlinson


