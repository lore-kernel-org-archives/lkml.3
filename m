Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3IHPOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 11:14:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41917 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3IHPOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:14:46 -0400
MIME-Version: 1.0
Message-ID: <3b488375-6998-4681-b105-e4c6d12ceca2@default>
Date: Sun, 8 Sep 2013 08:14:23 -0700 (PDT)
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: <michael.opdenacker@free-electrons.com>
Cc: <mingo@redhat.com>, <konrad.wilk@oracle.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xenproject.org>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] x86/xen: remove deprecated IRQF_DISABLED
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- michael.opdenacker@free-electrons.com wrote:

> This patch proposes to remove the IRQF_DISABLED flag from x86/xen
> code. It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker
> <michael.opdenacker@free-electrons.com>
> ---
>  arch/x86/xen/smp.c      | 10 +++++-----
>  arch/x86/xen/spinlock.c |  2 +-
>  arch/x86/xen/time.c     |  3 +--
>  3 files changed, 7 insertions(+), 8 deletions(-)


If you are cleaning up Xen's use of IRQF_DISABLED then you should
probably also update drivers/xen/evtchn.c and drivers/xen/platform-pci.c

-boris

