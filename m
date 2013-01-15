Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3AONsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:48:47 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63884 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab3AONsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:48:46 -0500
Date: Tue, 15 Jan 2013 05:49:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: cw00.choi@samsung.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [GIT PULL] extcon for 3.8-rc4
Message-ID: <20130115134941.GA25473@kroah.com>
References: <50F5067A.2060104@samsung.com>
 <20130115113719.GD1748@kroah.com>
 <CAGTfZH2r9TaNEPQ5am-UFwQd9t_qegxfo3MMOwJxvfctid7=-Q@mail.gmail.com>
 <20130115121356.GA2349@kroah.com>
 <CAGTfZH27VUuqqx5b4trMSDDDceWqwHE2wqPZdLbWvvBvbrzpKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGTfZH27VUuqqx5b4trMSDDDceWqwHE2wqPZdLbWvvBvbrzpKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 10:23:44PM +0900, Chanwoo Choi wrote:
> On Tuesday, January 15, 2013, Greg KH wrote:
> 
>     On Tue, Jan 15, 2013 at 09:09:20PM +0900, Chanwoo Choi wrote:
>     > On Tuesday, January 15, 2013, Greg KH wrote:
>     >
>     >     On Tue, Jan 15, 2013 at 04:34:18PM +0900, Chanwoo Choi wrote:
>     >     > Hi Greg,
>     >     >
>     >     > This is the extcon pull request for Linux 3.8-rc4.
>     >     >
>     >     > Please pull extcon with following updates:
>     >     >
>     >     > Update to max77693/max8997 extcon driver:
>     >     > - Using MHL_TA cable for charging.
>     >     > - Support JIG cable.
>     >     > - Support Dock-Audio device for playing music and button of device.
>     >     > - Support Dock-Smart device for desktop mode with mouse/keyboard.
>     >     > - Set default UART/USB path on probe().
>     >     > - Check the state/type of cable after completing initialization.
>     >     > - Code clean to remove duplicate code and bug fix related to
>     sequence of
>     >     interrupt.
>     >     > - Fix irq_flag of max8997/max77693 driver.
>     >     >
>     >     > Update to arizona extcon driver:
>     >     > - Headphone measurements.
>     >     > - Alternative detection mechanism for non-default system designs.
>     >     > - Microphone clamp integration.
>     >     > - Support for additional detection pin.
>     >     > - MICBIAS rise time configuration.
>     >     >
>     >     > Thanks in advance for pulling,
>     >
>     >     This request is for inclusion in 3.9, right?  This seems much too big
>     >     for 3.8 at the moment.
>     >
>     >  
>     > If you think that, I agree your opinion about including this request in
>     3.9.
> 
>     That's really up to you, as a subsystem maintainer, to decide about.
>     You need to take bugfixes and ask for them to be included in the 3.8,
>     and new features and other work, for 3.9.
> 
>  OK, I will resend pull-request to include only bugfixes patch in 3.8.
> After released v3.8-rc7 or 3.8-rc8 kernel, I will send pull-request of extcon
> to include new feature patches of extcon driver in 3.9.

No, you can send me that pull request now as well, I have two different
branches, one to go to Linus for this release, and one for the next one.
Both of them show up in linux-next.  You should have the same.

So you can send me two pull requests now, does that make more sense?

thanks,

greg k-h
