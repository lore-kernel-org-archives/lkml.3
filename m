Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3EWCZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 22:25:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:9795 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab3EWCZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 22:25:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,725,1363158000"; 
   d="scan'208";a="342042270"
Message-ID: <1369275908.2036.11.camel@rzhang1-mobl4>
Subject: Re: Fans at full speed after resume
From: Zhang Rui <rui.zhang@intel.com>
To: Michael =?ISO-8859-1?Q?Gro=DFh=E4user?= 
	<michael.grosshaeuser@t-online.de>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 23 May 2013 10:25:08 +0800
In-Reply-To: <knj3oe$h88$1@ger.gmane.org>
References: <CAPz6YkWr_D504UdeqXB0FXxgqOt3GYnF09ctoMaZ8P-znbVMGQ@mail.gmail.com>
	 <1368591999.5890.9.camel@rzhang1-mobl4>
	 <1368592193.5890.10.camel@rzhang1-mobl4> <knj3oe$h88$1@ger.gmane.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 20:46 +0200, Michael Großhäuser wrote:
> Zhang Rui wrote:
> 
> > On Wed, 2013-05-15 at 12:26 +0800, Zhang Rui wrote:
> >> please
> >> 
> >> On Tue, 2013-05-14 at 21:18 -0700, Sonny Rao wrote:
> >> > Hi, I've seen a regression in kernels since 3.7 on x86 devices where
> >> > the kernel turns the system fans on to max speed after resuming from
> >> > ram.  Other people have noticed it as well, for example see
> >> > https://bugzilla.redhat.com/show_bug.cgi?id=895276
> >> > 
> >> please check if this is a duplicate of bug
> >> https://bugzilla.kernel.org/show_bug.cgi?id=56591
> > or you can try 3.10-rc1 to see if the problem still exists or not.
> > 
> > thanks,
> > rui
> 
> 
> Hi,
> 
> I can confirm the same problem on a HP/Compaq 2510p with 3.10-rc2.
> 
please check if this is a duplicate of bug
https://bugzilla.kernel.org/show_bug.cgi?id=58301

please try the patch at comment #7 and see if it helps or not.

thanks,
rui
> Best Regards,
> Michael
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


