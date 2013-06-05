Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3FEMXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:23:38 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:63857 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab3FEMXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:23:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,806,1363132800"; 
   d="scan'208";a="5350946"
Message-ID: <1370435014.24512.190.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v3 5/6] arm64/xen: introduce CONFIG_XEN and hypercall.S
 on ARM64
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <konrad.wilk@oracle.com>
Date: Wed, 5 Jun 2013 13:23:34 +0100
In-Reply-To: <1370434530-22428-5-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
	 <1370434530-22428-5-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 13:15 +0100, Stefano Stabellini wrote:
> Introduce CONFIG_XEN and the implementation of hypercall.S (that is
> the only ARMv8 specific code in Xen support for ARM).
> 
> Compile enlighten.c and grant_table.c from arch/arm.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

> [....]
> +#define HYPERCALL_SIMPLE(hypercall)		\
> +ENTRY(HYPERVISOR_##hypercall)			\
> +	mov x16, #__HYPERVISOR_##hypercall;	\
> +	hvc XEN_IMM;						\
> +	ret;								\

Not sure if this is corruption due to whitespace/email etc but it'd be
nice to align those \'s.

Ian.


