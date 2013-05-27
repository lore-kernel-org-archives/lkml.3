Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3E0FE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 01:04:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:24271 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3E0FEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 01:04:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,748,1363158000"; 
   d="scan'208";a="308267844"
Message-ID: <1369631068.2159.2.camel@rzhang1-mobl4>
Subject: Re: Fans at full speed after resume
From: Zhang Rui <rui.zhang@intel.com>
To: Michael =?ISO-8859-1?Q?Gro=DFh=E4user?= 
	<michael.grosshaeuser@t-online.de>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 27 May 2013 13:04:28 +0800
In-Reply-To: <1Ufc0I-09RzDk0@fwd03.t-online.de>
References: <CAPz6YkWr_D504UdeqXB0FXxgqOt3GYnF09ctoMaZ8P-znbVMGQ@mail.gmail.com>
	 <1368591999.5890.9.camel@rzhang1-mobl4>
	 <1368592193.5890.10.camel@rzhang1-mobl4> <knj3oe$h88$1@ger.gmane.org>
	 <1369275908.2036.11.camel@rzhang1-mobl4> <1Ufc0I-09RzDk0@fwd03.t-online.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-23 at 22:22 +0200, Michael Großhäuser wrote:
> Zhang Rui wrote:
> 
> > On Wed, 2013-05-22 at 20:46 +0200, Michael Großhäuser wrote:
> >> Zhang Rui wrote:
> >> 
> >> > On Wed, 2013-05-15 at 12:26 +0800, Zhang Rui wrote:
> >> >> please
> >> >> 
> >> >> On Tue, 2013-05-14 at 21:18 -0700, Sonny Rao wrote:
> >> >> > Hi, I've seen a regression in kernels since 3.7 on x86 devices where
> >> >> > the kernel turns the system fans on to max speed after resuming from
> >> >> > ram.  Other people have noticed it as well, for example see
> >> >> > https://bugzilla.redhat.com/show_bug.cgi?id=895276
> >> >> > 
> >> >> please check if this is a duplicate of bug
> >> >> https://bugzilla.kernel.org/show_bug.cgi?id=56591
> >> > or you can try 3.10-rc1 to see if the problem still exists or not.
> >> > 
> >> > thanks,
> >> > rui
> >> 
> >> 
> >> Hi,
> >> 
> >> I can confirm the same problem on a HP/Compaq 2510p with 3.10-rc2.
> >> 
> > please check if this is a duplicate of bug
> > https://bugzilla.kernel.org/show_bug.cgi?id=58301
> > 
> > please try the patch at comment #7 and see if it helps or not.
> > 
Good to know.
then could you please try the four patches in comment #10, #11, #12 and
#13 in
https://bugzilla.kernel.org/show_bug.cgi?id=58301
without the previous patch and check if they help?

These four patches are the fixes that I would push for upstream.

thanks,
rui
> > thanks,
> > rui
> 
> Hi,
> 
> the patch fixes the problem for me.
> 
> Thanks,
> Michael 
> 
> 
> >> Best Regards,
> >> Michael
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html


