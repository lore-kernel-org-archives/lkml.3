Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3KXKl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 05:41:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55899 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3KXKlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 05:41:25 -0500
Date: Sun, 24 Nov 2013 11:41:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: IRQF_RESUME_EARLY and errors in dpm_suspend_noirq
Message-ID: <20131124104124.GA22947@amd.pavel.ucw.cz>
References: <201311201020.08158.heiko@sntech.de>
 <528C86C2.1070206@nvidia.com>
 <201311232225.48973.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201311232225.48973.heiko@sntech.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-11-23 22:25:48, Heiko Stübner wrote:
> Hi Laxman,
> 
> Am Mittwoch, 20. November 2013, 10:54:10 schrieb Laxman Dewangan:
> > > I may be blind, but where get the early-irqs resumed in the error
> > > path of dpm_suspend_noirq?
> > > 
> > > When a suspend_noirq callback returns an error, dpm_resume_noirq gets
> > > called, which only calls resume_device_irqs while the
> > > suspend_device_irqs call in dpm_suspend_noirq suspends all irqs. So it
> > > does not seem that the early-irqs get resumed at all in this case.
> > 
> > I also faced same issue in our suspend failure path and posted fix
> > sometime ago as
> > https://lkml.org/lkml/2013/8/13/373
> > 
> > It is still under review.

If it helps, you can add my

Reviewed-by: Pavel Machek <pavel@ucw.cz>

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
