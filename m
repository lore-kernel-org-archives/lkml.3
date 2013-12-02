Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab3LBQ1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:27:23 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:38913 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103Ab3LBQ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:27:20 -0500
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 11:27:20 EST
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Souvik Banerjee <souvik1997@gmail.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: vboxhost fails to build on 3.13
Date: Mon, 02 Dec 2013 17:17:55 +0100
Message-ID: <1821868.Zl9MnkIPDQ@ws-stein>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CA+5PVA6ngjQPvMjzc3DcbOJXRavqk=pzdvTYUyZ9-W+bHDyNrQ@mail.gmail.com>
References: <CAA_L7Z76=97VL5jnjW_1=9vLiKVOYDzs4W0XUw0tW9UDVeKm0A@mail.gmail.com> <CA+5PVA6ngjQPvMjzc3DcbOJXRavqk=pzdvTYUyZ9-W+bHDyNrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 December 2013 11:02:10, Josh Boyer wrote:
> On Thu, Nov 28, 2013 at 1:17 PM, Souvik Banerjee <souvik1997@gmail.com> wrote:
> > commit 930aa174fcc8b0efaad102fd80f677b92f35eaa2
> > Author: Mel Gorman <mgorman@suse.de>
> > Date:   Mon Oct 7 11:29:37 2013 +0100
> >
> >     sched/numa: Remove the numa_balancing_scan_period_reset sysctl
> 
> Then vboxhost needs to be modified to work with the newer kernel.
> That's what happens when they keep the drivers out-of-tree.  You
> should report the issue to the vbox people as they're the only ones in
> a position to actually fix their driver.

Even better use current version which has the fix included (https://www.virtualbox.org/wiki/Changelog):
VirtualBox 4.3.4 (released 2013-11-29)
[...]
Linux hosts / guests: Linux 3.13 compile fixes (bug #12358)

Regards,
Alexander

