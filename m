Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaKGESF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:18:05 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54166 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751346AbaKGESA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:18:00 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19AEvorYSdVIl0OqVdjlI33+CiaQJpYWO4=
X-DKIM: OpenDKIM Filter v2.0.1 titan CE174613F6F
Date: Thu, 6 Nov 2014 23:17:42 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 3/4] irqchip: mips-gic: Add device-tree support
Message-ID: <20141107041742.GH3698@titan.lakedaemon.net>
References: <1414624790-15690-1-git-send-email-abrestic@chromium.org>
 <1414624790-15690-4-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414624790-15690-4-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Wed, Oct 29, 2014 at 04:19:49PM -0700, Andrew Bresticker wrote:
> Add device-tree support for the MIPS GIC.  Update the GIC irqdomain's
> xlate() callback to handle the three-cell specifier described in the
> MIPS GIC binding document.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes from v3:
>  - use reserved-cpu-vectors property
>  - read GIC base from CM if no reg property present
> Changes from v2:
>  - rebased on GIC irqchip cleanups
>  - updated for change in bindings
>  - only parse first CPU vector
>  - allow platforms to use EIC mode
> Changes from v1:
>  - updated for change in bindings
>  - set base address and enable bit in GCR_GIC_BASE
> ---
>  drivers/irqchip/irq-mips-gic.c | 92 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 87 insertions(+), 5 deletions(-)

I assume this is going though the mips tree...

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
