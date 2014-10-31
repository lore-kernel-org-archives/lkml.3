Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbaJaSxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:53:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:45183 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbaJaSxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:53:41 -0400
Date: Fri, 31 Oct 2014 19:53:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: Juergen Gross <jgross@suse.com>, hpa@zytor.com, x86@kernel.org,
        mingo@redhat.com, stefan.bader@canonical.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, ville.syrjala@linux.intel.com,
        david.vrabel@citrix.com, jbeulich@suse.com, toshi.kani@hp.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH 00/17] x86: Full support of PAT
In-Reply-To: <20141031140600.GA31014@gmail.com>
Message-ID: <alpine.DEB.2.11.1410311951230.5308@nanos>
References: <1414764033-30011-1-git-send-email-jgross@suse.com> <20141031140600.GA31014@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Ingo Molnar wrote:
> 
> * Juergen Gross <jgross@suse.com> wrote:
> 
> > Changes in V5:
> > - split up first patch as requested by Ingo Molnar and Thomas Gleixner
> > - add a helper function in pat_init_cache_modes() as requested by Ingo Molnar
> 
> The structure of this series looks great to me now.

And it actually was a pleasure to review.
 
> Just to make sure: the series is fully bisectable, it is supposed 
> to build and boot at every patch in the series, right?
> 
> If nobody objects then I'll start applying this series in a 
> couple of days.

I did not find anything except the question about losing the large pat
bit. If that's resolved its good to go.

Please add

  Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
 
to the whole series.

Thanks,

	tglx
