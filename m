Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab3HTQCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:02:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3HTQCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:02:05 -0400
Date: Tue, 20 Aug 2013 09:03:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
        Shuah Khan <shuah.kh@samsung.com>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/34] 3.4.59-stable review
Message-ID: <20130820160355.GA9427@kroah.com>
References: <20130818203259.653403173@linuxfoundation.org>
 <52125DA9.3090601@samsung.com>
 <20130819193538.GB24897@kroah.com>
 <201308192214.54917.s.L-H@gmx.de>
 <52129AC3.5020402@samsung.com>
 <20130819223037.GA3838@kroah.com>
 <1DC40B07CD6EC041A66726C271A73AE61AA6B9CC@IRSMSX102.ger.corp.intel.com>
 <20130820152401.GA5211@kroah.com>
 <alpine.LNX.2.00.1308200851190.991@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1308200851190.991@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:53:24AM -0700, Hugh Dickins wrote:
> On Tue, 20 Aug 2013, Greg Kroah-Hartman wrote:
> > On Tue, Aug 20, 2013 at 07:36:00AM +0000, Berg, Johannes wrote:
> > > > > [ 26/34] genetlink: fix family dump race
> > > > 
> > > > Johannes, another strike against this patch :(
> > > > 
> > > > Any chance on fixing it upstream and me sucking that fix in?
> > > 
> > > Yeah, I'm trying to get that, but it's not clear to me how to fix it.
> > > Where did you apply it? It was going to need some fixes but when the
> > > first objection was raised I figured you were going to drop it for now
> > > completely? Sorry for the mess :-(
> > 
> > You're right, I'll drop this for 3.4, it doesn't make sense there.
> 
> And you'll drop it from 3.0 and 3.10 also, I hope?

It wasn't in 3.0, was it?  Oh crap, it was...

3.10, I'd rather have the "real" fix that ends up resolving the issue in
Linus's tree also, instead of just dropping it.

Especially as I just did the releases...

thanks,

greg k-h
