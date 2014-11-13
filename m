Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbaKMSSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:18:13 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:38600 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648AbaKMSSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:18:12 -0500
Date: Thu, 13 Nov 2014 20:18:04 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Tony Lindgren <tony@atomide.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@kernel.org>,
        Pali Roh?r <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141113181803.GB984@fuloong-minipc.musicnaut.iki.fi>
References: <20141104205117.GA17606@amd>
 <201411052137.31452@pali>
 <20141105203918.GA29199@amd>
 <201411052206.05379@pali>
 <20141105220359.GA32052@amd>
 <20141105234555.GA7097@earth.universe>
 <20141106124711.GA26944@amd>
 <20141106180335.GA21513@earth.universe>
 <20141113162155.GA8512@xo-6d-61-c0.localdomain>
 <20141113174534.GO26481@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113174534.GO26481@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 13, 2014 at 09:45:36AM -0800, Tony Lindgren wrote:
> * Pavel Machek <pavel@ucw.cz> [141113 08:23]:
> > OTOH ofono seems pretty reasonable. So I played a bit, and result
> > is python/pygtk gui which can receive an sms, initiate a call, and
> > report missed call. If someone wants to play, source is at
> > 
> > https://gitorious.org/tui/tui/source/b6141107e9341a1412720aed4b0d09143dfa2f4e:ofone
> 
> Pavel, care to fill in the the following type patch with some
> instructions in the description now that you got it working?

Could we even have some "permanent" instructions under Documentation/?

> I did not have luck yet when I tried. I got the /dev/cmt/*
> entries after adding pm=1 param, but no luck scanning any networks.

I haven't tested anything yet, but looking forward to do that during
the weekend... Sounds pretty exciting. :-)

A.
