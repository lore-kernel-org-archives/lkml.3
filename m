Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3BZLHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:07:52 -0500
Received: from sauhun.de ([89.238.76.85]:58739 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab3BZLHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:07:50 -0500
Date: Tue, 26 Feb 2013 12:07:47 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: =?utf-8?B?7Iah7J2A67SJ?= <eunb.song@samsung.com>,
        linux-kernel@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: Re: I2C: Fix i2c fail problem when a process is terminated by a
 signal on octeon  in 3.8
Message-ID: <20130226110740.GA3962@katana>
References: <88.A5.02716.F6CB6215@epcpsbge3.samsung.com>
 <alpine.LNX.2.00.1302261101250.2128@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1302261101250.2128@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 11:02:17AM +0100, Jiri Kosina wrote:
> On Fri, 22 Feb 2013, 송은봉 wrote:
> 
> > 
> >  
> > 
> > I've been debugging the abnormal operation of i2c on octeon.
> > If a process is terminated by signal in the middle of i2c operation,
> > next i2c read operation which is done by another process was failed.
> > So i changed to ignore signal in the middle of i2c operation.
> > After that the problem was not reproduced.
> 
> This is not really material directly for trivial.git. Adding maintainers 
> to CC.

Yes, this should not go via trivial. Please resend to i2c list. Patch
looks okay from a glimpse (and fixes an issue we have seen before and
fixed the same way).

Thanks,

   Wolfram

