Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab3DQTsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:48:39 -0400
Received: from relay2.sgi.com ([192.48.179.30]:41701 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758735Ab3DQTsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:48:37 -0400
Date: Wed, 17 Apr 2013 14:48:36 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v5 5/5] Make reboot_cpuid a kernel parameter.
Message-ID: <20130417194836.GK3658@sgi.com>
References: <1366224198-49485-1-git-send-email-holt@sgi.com>
 <1366224198-49485-6-git-send-email-holt@sgi.com>
 <516EF9DE.6000707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516EF9DE.6000707@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 12:37:02PM -0700, H. Peter Anvin wrote:
> On 04/17/2013 11:43 AM, Robin Holt wrote:
> > Moving the reboot=s<##> parameter for x86 to a kernel parameter
> > proper.  I did not find any other arch that was specifying the
> > reboot cpu.
> > 
> > I left a compatibility mode in there.  The new parameter always
> > takes precedence.  I also fixed up the current code to support
> > up to cpuid's up to the current max of 4096.
> > 
> 
> I still don't understand why you insist on introducing a new parameter
> rather than just supporting the existing, somewhat ugly, syntax: it is
> rare enough to need that the compatibility wins over the aestetics.

Did you see my response I sent this morning?

I would really like to try and remove the apparently unused reboot=
parameter from arm and unicore32 as well.  Does anybody have a concern
with that?  That should make documenting slightly easier.

> Furthermore that word "cpuid" that you keep using, I don't think it
> means what you think it means...

If we stayed with the core_param, would you prefer reboot_processor=###
over reboot_cpuid=###?

Robin
