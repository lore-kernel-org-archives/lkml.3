Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaJNJOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:14:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:58581 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbaJNJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:14:30 -0400
Date: Tue, 14 Oct 2014 11:14:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Thomas Shao <huishao@microsoft.com>
cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] hyperv: Implement Time Synchronization using host time
 sample
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540BF785@HKXPRD3002MB006.064d.mgd.msft.net>
Message-ID: <alpine.DEB.2.11.1410141113470.5354@nanos>
References: <1413275026-5645-1-git-send-email-huishao@microsoft.com> <20141014073525.GA3189@kroah.com> <CD2CABCB2C0A0D4682C5F8AD840141540BF785@HKXPRD3002MB006.064d.mgd.msft.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2014, Thomas Shao wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Tuesday, October 14, 2014 3:35 PM
> > To: Thomas Shao
> > Cc: tglx@linutronix.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; KY Srinivasan
> > Subject: Re: [PATCH] hyperv: Implement Time Synchronization using host
> > time sample
> > 
> > On Tue, Oct 14, 2014 at 01:23:46AM -0700, Thomas Shao wrote:
> > > --- a/kernel/time/timekeeping.c
> > > +++ b/kernel/time/timekeeping.c
> > > @@ -1786,6 +1786,7 @@ int do_adjtimex(struct timex *txc)
> > >
> > >  	return ret;
> > >  }
> > > +EXPORT_SYMBOL(do_adjtimex);
> > 
> > EXPORT_SYMBOL_GPL()?
> 
> Oh, yes,  I should use EXPORT_SYMBOL_GPL. I'll send a new patch. Thanks Greg.

And please make that export a separate patch. 

Thanks,

	tglx
