Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbaEPQ3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:29:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:40665 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaEPQ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:29:51 -0400
Date: Fri, 16 May 2014 18:29:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140516162945.GZ11096@twins.programming.kicks-ass.net>
References: <537119EF.2060102@oracle.com>
 <20140512200135.GL1421@htj.dyndns.org>
 <53718119.1090000@cn.fujitsu.com>
 <537180B9.6080407@oracle.com>
 <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
 <20140516115737.GP11096@twins.programming.kicks-ass.net>
 <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D+MycPccvPlP5/X+"
Content-Disposition: inline
In-Reply-To: <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D+MycPccvPlP5/X+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 17, 2014 at 12:18:06AM +0800, Lai Jiangshan wrote:
> so the scheduler/set_cpus_allowed_ptr()/cpu_active_mask should be the first
> place to fix.

I'm not arguing about that, not to mention that this is userspace
exposed and nobody protects that.

But I was expecting kernel stuff that calls it on hotplug to be
serialized thusly, but apparently not so.

--D+MycPccvPlP5/X+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdjz5AAoJEHZH4aRLwOS6ktIQAIqCb/Aas2qPHMCX1uWvg5bL
+xOGLkUdLP1blVCznPOMxOfFuPlX+/ZM5zHcDTudGlHgTifYHZxCgxKauQH1YhBz
Cs+qPhp/u1B12okm9xS8rTOE2Pkcd0b8RxZplBJQo2OC/gIH6X+/wLOZvvz2Kp06
plsYCBUK1jSiRmrSSd/CigWFo/h+IVut4UzoRCajgrnDl2uYvdUooLDQITmUBjoD
MABDV4JUh3jMY6dWoYQ+/kYiV/VAK7is4BVXvR1QMZyJV9aFkjWyqVgoBFgpViwn
RPqDPFGvrIZliIJTxd4SUVOtXhpsYfXMMUp+x+9K8ZKKX7aE9qAS1jD0FJhHtrPY
zLGSHBJYP5NTR20dSKzlxE67UESBmDllS3Iv6opszVNBaR/Q4IeJPZh+3cgYXa+h
cppyKboFh7os8yMDliW1Blee5T5BMiYjuLGwcKxqpXRAPSaxJ3KRmfAIPsmG6XQ+
JN+Pl+XcR6CDNuchYKU2MSKNpyGNHQG5kUO1AMc8WzCbt7dXhiyYu6If94JGyit0
bFmNBcr+qco1DFPivibh/F6zXg+5y2WWpx90q7UM5J78tw+wxXXShjHFbEvhYKIO
sV+O4jULCBwYcgj5AlsXUtCG3e0LSbyzmDckpffEqilx725/Y8LWU6lsdMQVxP8z
KCJXJydsRR4cPS86mMgs
=kuAC
-----END PGP SIGNATURE-----

--D+MycPccvPlP5/X+--
