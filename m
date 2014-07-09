Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbaGIMKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:10:24 -0400
Received: from smtp.citrix.com ([66.165.176.89]:42151 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbaGIMKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:10:23 -0400
X-IronPort-AV: E=Sophos;i="5.01,631,1400025600"; 
   d="scan'208";a="150930093"
Message-ID: <53BD311B.2050404@citrix.com>
Date: Wed, 9 Jul 2014 13:10:03 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <konrad@kernel.org>, <xen-devel@lists.xenproject.org>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v2] xen: Introduce 'xen_nopv' to disable PV
 extensions for HVM guests.
References: <1404852745-25187-1-git-send-email-konrad@kernel.org>
In-Reply-To: <1404852745-25187-1-git-send-email-konrad@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 21:52, konrad@kernel.org wrote:
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> By default when CONFIG_XEN and CONFIG_XEN_PVHVM kernels are
> run, they will enable the PV extensions (drivers, interrupts, timers,
> etc) - which is perfect.

If it's "perfect" what's this option for? ;)

I think you mean to say "which is the best option for the majority of
use cases".

> However, in some cases (kexec not fully wokring, benchmarking)
> we want to disable Xen PV extensions. As such introduce the
> 'xen_nopv' parameter that will do it.

"working"

I'm unconvinced about the utility of this option.  The resulting kernel
will go like molasses and I'm not sure what the use of being any to
benchmark a configuration no one will use in practice.  But it's a small
patch so

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David

