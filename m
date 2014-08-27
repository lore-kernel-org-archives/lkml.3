Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbaH0XXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:23:32 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:33595 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965120AbaH0XXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:23:31 -0400
Date: Wed, 27 Aug 2014 18:23:28 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH percpu/for-3.18-consistent-ops] Revert "powerpc: Replace
 __get_cpu_var uses"
In-Reply-To: <20140828074937.47020590@canb.auug.org.au>
Message-ID: <alpine.DEB.2.11.1408271823040.25336@gentwo.org>
References: <20140827142243.6277eaff@canb.auug.org.au> <20140827152609.GA379@htj.dyndns.org> <alpine.DEB.2.11.1408271055030.17080@gentwo.org> <20140828074937.47020590@canb.auug.org.au>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Stephen Rothwell wrote:

> > Ok. Once I figure out what went wrong. This went through Feng's build
> > system and I though he did a powerpc build. So it must be a difference
> > configuration on powerpc.
>
> Were the patches tested on top of v3.17-rc1?  My build was a powerpc
> ppc64_defconfig.  It is possible that some other change interacted with
> this, but there are not many other arch/powerpc changes after v3.17-rc1
> and none seem obvious.

Yes the latest build test by Feng was on rc1.

