Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbaGNP10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:27:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45165 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbaGNP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:27:19 -0400
Date: Mon, 14 Jul 2014 11:26:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <daniel.kiper@oracle.com>, matt.fleming@intel.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com, hpa@zytor.com,
        ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org,
        matt.fleming@intel.com, mingo@redhat.com,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v2 0/2] xen: Silence compiler warnings
Message-ID: <20140714152641.GB6386@laptop.dumpdata.com>
References: <1405199388-5692-1-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405199388-5692-1-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 11:09:46PM +0200, Daniel Kiper wrote:
> Hi,
> 
> Here are two patches that follow earlier Xen dom0 EFI series and
> fix some compiler warnings found during detailed build tests.
> 
> Both patches should be applied to:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next

Hey Matt,

David Vrabel (who reviewed them earlier and is also an maintainer
of the Xen tree) is out on vacation so I am responding here.

I reviewed the patches and hopefully my mailer (Android phone)
sent it correctly. If not, all of them can have the Reviewed-by:
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> tag on them.

If you would be so kind and pull them in your git tree -
that would be appreciated!

Thanks!
> 
> v2 contains fix suggested by Konrad Rzeszutek Wilk.
> 
> Daniel
> 
> PS I will be on vacation from 14th Jul till 25th Jul.
> 
>  arch/x86/xen/Makefile    |    1 +
>  arch/x86/xen/efi.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/xen/enlighten.c |   15 +--------------
>  arch/x86/xen/xen-ops.h   |    8 ++++++++
>  include/xen/xen-ops.h    |    2 +-
>  5 files changed, 54 insertions(+), 15 deletions(-)
> 
> Daniel Kiper (2):
>       xen: Silence compiler warnings
>       arch/x86/xen: Silence compiler warnings
> 
