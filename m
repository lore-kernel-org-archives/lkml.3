Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3CAGov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:44:51 -0500
Received: from magic.merlins.org ([209.81.13.136]:50542 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3CAGot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:44:49 -0500
Date: Thu, 28 Feb 2013 22:44:46 -0800
From: Marc MERLIN <marc@merlins.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, desnoyers@efficios.com
Subject: Re: Reproduceable SATA lockup on 3.7.8 with SSD
Message-ID: <20130301064446.GA21808@merlins.org>
References: <20130226002731.GC25875@merlins.org> <512CD4F7.806@pobox.com> <20130226002731.GC25875@merlins.org> <20130226010232.GA18133@Krystal> <20130226165004.GD22367@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226165004.GD22367@merlins.org>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 3.1.5-core2-volpreempt-noide-hm64-20111218/Debian squeeze/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 08:50:04AM -0800, Marc MERLIN wrote:
> On Tue, Feb 26, 2013 at 10:29:59AM -0500, Jeff Garzik wrote:
> > On 02/25/2013 07:27 PM, Marc MERLIN wrote:
> > >Howdy,
> > >
> > >I seem to have the same problem (or similar) as Mathieu Desnoyers in
> > >https://lkml.org/lkml/2013/2/22/437
> > >
> > >I can reliably get my SSD to drop from the SATA bus given the right 
> > >workload
> > >on linux.
> > >
> > >How can I tell if it's linux's fault of the drive's fault?
> > 
> > Manually force speed to 3.0 Gbps, then 1.5 Gbps, and see what happens.
> > 
> > Try module/kernel parameter libata.force=1.5Gbps or libata.force=3.0Gbps
> 
> Ok, so by reading my log at time of failure, you saw that speed was
> flipping between the two? (I couldn't see that, but I'm not good at reading
> it).
> 
> Also, just to make sure, you're not saying that you want me to change the
> speed at runtime, but 
> 1) boot once with speed forced at 3Gbps and try and reproduce
> 2) boot a 2nd time with speed forced at 1.5Gbps and try and reproduce
> 
> If libata is not a module in my kernel, I can still put 
> libata.force=1.5Gbps 
> on the lilo/grub command line, correct?

Jeff, could you clear up what you'd like me to try out?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
