Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaLCOyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:54:24 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39765 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaLCOyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:54:22 -0500
Date: Wed, 3 Dec 2014 09:54:18 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141203145418.GA5013@htj.dyndns.org>
References: <547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
 <20141202184202.GM25340@linux.vnet.ibm.com>
 <547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
 <20141202191143.GN25340@linux.vnet.ibm.com>
 <547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
 <20141202205636.GQ25340@linux.vnet.ibm.com>
 <547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
 <CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
 <547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
 <CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 02, 2014 at 08:14:52PM -0800, Linus Torvalds wrote:
> I added Tejun to the Cc, just because I wanted to give him a heads-up
> that I am tentatively starting to blame him in my dark little mind..

Yeap, keeping watch on the thread and working on a patch to dump more
workqueue info on sysrq (I don't know which sysrq alphabet to hang it
on yet, mostly likely it'd get appeneded to tasks dump).  For all
three subsystems, for-3.17 pulls contained quite a bit of changes.
I've skimmed through the commits but nothing rings the bell - I've
never seen this pattern of failures in any of the three subsystems.
Maybe a subtle percpu bug or cpuset messing up scheduling somehow?
Anyways, let's see how 47dfe4037 does.

Thanks.

-- 
tejun
