Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762366Ab3IDLq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 07:46:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53238 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab3IDLq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 07:46:26 -0400
Message-ID: <52271D5E.4060402@zytor.com>
Date: Wed, 04 Sep 2013 04:45:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alok Kataria <akataria@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Covelli <dcovelli@vmware.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] Add an entry in MAINTAINERS for VMware's hypervisor interface
References: <1378284821.9739.7404.camel@akataria-dtop.eng.vmware.com>
In-Reply-To: <1378284821.9739.7404.camel@akataria-dtop.eng.vmware.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:53 AM, Alok Kataria wrote:
> Hey,
> 
> This change adds an entry to the maintainers file to explicitly state
> that any changes to vmware.c should be sent to the authors of the file
> as well.
> 
> If you are thinking why do this now, off late we have seen quite a few
> changes that touched the "arch/x86/kernel/cpu/vmware.c" file but were
> not directed to me, someone else made me aware of those changes. It
> could be that my use of different SOB lines "Alok N Kataria" vs "Alok
> Kataria" confuses get_maintainer.pl, but adding this entry in
> MAINTAINERS should solve the problem at hand. For one of the changes
> [1], I did verify that get_maintainer.pl, now expectedly includes me in
> the cc list.
> 
> Thanks,
> Alok 
> 

That is indeed what the maintainers file is for.

> Add an entry in MAINTAINERS file to reflect the authors of a file.

No, it reflects the *maintainer(s)* of a file.

	-hpa

