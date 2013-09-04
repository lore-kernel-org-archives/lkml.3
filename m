Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763179Ab3IDRpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:45:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34649 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756932Ab3IDRpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:45:09 -0400
Message-ID: <1378314979.1787.24.camel@joe-AO722>
Subject: Re: [PATCH] Add an entry in MAINTAINERS for VMware's hypervisor
 interface
From: Joe Perches <joe@perches.com>
To: Alok Kataria <akataria@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Covelli <dcovelli@vmware.com>,
        virtualization@lists.linux-foundation.org
In-Reply-To: <1378284821.9739.7404.camel@akataria-dtop.eng.vmware.com>
References: <1378284821.9739.7404.camel@akataria-dtop.eng.vmware.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 04 Sep 2013 10:16:19 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.4-0ubuntu1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-04 at 14:23 +0530, Alok Kataria wrote:
> Hey,
> 
> This change adds an entry to the maintainers file to explicitly state
> that any changes to vmware.c should be sent to the authors of the file
> as well.

It never hurts to add MAINTAINER entries.

> If you are thinking why do this now, off late we have seen quite a few
> changes that touched the "arch/x86/kernel/cpu/vmware.c" file but were
> not directed to me, someone else made me aware of those changes.

Many people don't use get_maintainer

> It
> could be that my use of different SOB lines "Alok N Kataria" vs "Alok
> Kataria" confuses get_maintainer.pl,

That shouldn't be a problem unless the email addresses are
also different.

> +++ linux-2.6/MAINTAINERS	2013-09-04 14:20:39.714026943 +0530
[]
> +VMWARE HYPERVISOR INTERFACE
> +M: Alok Kataria <akataria@vmware.com>
> +L: virtualization@lists.linux-foundation.org
> +S: Supported
> +F: arch/x86/kernel/cpu/vmware.c
> +

It'd be nicer to use tabs after the colon


