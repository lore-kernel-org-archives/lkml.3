Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaI1Bu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 21:50:27 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:18636 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753090AbaI1BuZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 21:50:25 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Catalin Marinas'" <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Will Deacon <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-msm@vger.kernel.org'" <linux-arm-msm@vger.kernel.org>,
        =?iso-8859-1?Q?=27Uwe_Kleine-K=F6nig=27?= 
	<u.kleine-koenig@pengutronix.de>,
        DL-WW-ContributionOfficers-Linux 
	<DL-WW-ContributionOfficers-Linux@sonymobile.com>
Date: Sun, 28 Sep 2014 09:50:21 +0800
Subject: RE: [PATCH resend] arm:extend the reserved memory for initrd to be
 page aligned
Thread-Topic: [PATCH resend] arm:extend the reserved memory for initrd to be
 page aligned
Thread-Index: Ac/Y15GJS/OdjTIxTdagaUoaJnJjvQB5tB9A
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB49163E@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103D6DB49161F@CNBJMBX05.corpusers.net>
 <20140919095959.GA2295@e104818-lin.cambridge.arm.com>
 <20140925143142.GF5182@n2100.arm.linux.org.uk>
 <20140925154403.GL10390@e104818-lin.cambridge.arm.com>
In-Reply-To: <20140925154403.GL10390@e104818-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> On Thu, Sep 25, 2014 at 03:31:42PM +0100, Russell King - ARM Linux wrote:
> > On Fri, Sep 19, 2014 at 11:00:02AM +0100, Catalin Marinas wrote:
> > > On Fri, Sep 19, 2014 at 08:09:47AM +0100, Wang, Yalin wrote:
> > > > this patch extend the start and end address of initrd to be page
> > > > aligned, so that we can free all memory including the un-page
> > > > aligned head or tail page of initrd, if the start or end address
> > > > of initrd are not page aligned, the page can't be freed by
> free_initrd_mem() function.
> > > >
> > > > Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> > >
> > > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > >
> > > (as I said, if Russell doesn't have any objections please send the
> > > patch to his patch system)
> >
> > I now have an objection.  The patches in the emails were properly
> formatted.
> 
> They were so close ;)
> 
> I can see three patches but none of them exactly right:
> 
> 8157/1 - wrong diff format
> 8159/1 - correct format, does not have my ack (you can take this one if
> 	 you want)
> 8162/1 - got my ack this time but with the wrong diff format again
> 
> Maybe a pull request is a better idea.
> 
I have resend the 2 patches:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8167/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8168/1
 
please have a look.

Thanks



