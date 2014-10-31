Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbaJaOGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:06:08 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34219 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760863AbaJaOGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:06:05 -0400
Date: Fri, 31 Oct 2014 15:06:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Juergen Gross <jgross@suse.com>
Cc: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH 00/17] x86: Full support of PAT
Message-ID: <20141031140600.GA31014@gmail.com>
References: <1414764033-30011-1-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414764033-30011-1-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Juergen Gross <jgross@suse.com> wrote:

> Changes in V5:
> - split up first patch as requested by Ingo Molnar and Thomas Gleixner
> - add a helper function in pat_init_cache_modes() as requested by Ingo Molnar

The structure of this series looks great to me now.

Just to make sure: the series is fully bisectable, it is supposed 
to build and boot at every patch in the series, right?

If nobody objects then I'll start applying this series in a 
couple of days.

Thanks,

	Ingo
