Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3IKVhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 17:37:04 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61863 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab3IKVhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 17:37:02 -0400
Date: Wed, 11 Sep 2013 23:36:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mike Galbraith <bitbucket@online.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130911213656.GA15367@somewhere>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
 <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
 <1378795659.6046.41.camel@marge.simpson.net>
 <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
 <1378797995.6046.54.camel@marge.simpson.net>
 <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com>
 <0000014109b5ec0e-ca64a736-ce4a-4be2-abf6-bbf2c1c15f80-000000@email.amazonses.com>
 <1378869632.5476.34.camel@marge.simpson.net>
 <000001410d659f85-21128fa5-a252-4006-804c-4ff03acbd50f-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001410d659f85-21128fa5-a252-4006-804c-4ff03acbd50f-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 02:21:06PM +0000, Christoph Lameter wrote:
> On Wed, 11 Sep 2013, Mike Galbraith wrote:
> 
> > Mind saying why?  To me, creating properties of exclusive sets of CPUs
> > that the interface which manages sets and their properties is not fully
> > aware of is a dainbramaged thing to do.
> 
> cpusets is being replaced by cgropus.

You are confusing me. Cpusets is a cgroups subsystem, how can it be replaced
by it?
