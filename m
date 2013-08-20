Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3HTPxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:53:47 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53412 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3HTPxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:53:45 -0400
Date: Tue, 20 Aug 2013 08:53:24 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: "Berg, Johannes" <johannes.berg@intel.com>,
        Shuah Khan <shuah.kh@samsung.com>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/34] 3.4.59-stable review
In-Reply-To: <20130820152401.GA5211@kroah.com>
Message-ID: <alpine.LNX.2.00.1308200851190.991@eggly.anvils>
References: <20130818203259.653403173@linuxfoundation.org> <52125DA9.3090601@samsung.com> <20130819193538.GB24897@kroah.com> <201308192214.54917.s.L-H@gmx.de> <52129AC3.5020402@samsung.com> <20130819223037.GA3838@kroah.com>
 <1DC40B07CD6EC041A66726C271A73AE61AA6B9CC@IRSMSX102.ger.corp.intel.com> <20130820152401.GA5211@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Greg Kroah-Hartman wrote:
> On Tue, Aug 20, 2013 at 07:36:00AM +0000, Berg, Johannes wrote:
> > > > [ 26/34] genetlink: fix family dump race
> > > 
> > > Johannes, another strike against this patch :(
> > > 
> > > Any chance on fixing it upstream and me sucking that fix in?
> > 
> > Yeah, I'm trying to get that, but it's not clear to me how to fix it.
> > Where did you apply it? It was going to need some fixes but when the
> > first objection was raised I figured you were going to drop it for now
> > completely? Sorry for the mess :-(
> 
> You're right, I'll drop this for 3.4, it doesn't make sense there.

And you'll drop it from 3.0 and 3.10 also, I hope?

Thanks,
Hugh
