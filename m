Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbbAWP6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:58:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:37350 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbbAWP6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:58:33 -0500
Date: Fri, 23 Jan 2015 16:58:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 1/8] dt: bindings: Supply shared ST IRQ
 defines
In-Reply-To: <1421920133-7914-2-git-send-email-lee.jones@linaro.org>
Message-ID: <alpine.DEB.2.11.1501231656310.5526@nanos>
References: <1421920133-7914-1-git-send-email-lee.jones@linaro.org> <1421920133-7914-2-git-send-email-lee.jones@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Lee Jones wrote:

> These defines are used to allow values used for configuration to be
> easily human readable and will lessen the chance of logical mistakes.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  include/dt-bindings/interrupt-controller/irq-st.h | 30 +++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 include/dt-bindings/interrupt-controller/irq-st.h
> 
> diff --git a/include/dt-bindings/interrupt-controller/irq-st.h b/include/dt-bindings/interrupt-controller/irq-st.h
> new file mode 100644
> index 0000000..4c59ace
> --- /dev/null
> +++ b/include/dt-bindings/interrupt-controller/irq-st.h
> @@ -0,0 +1,30 @@
> +/*
> + *  include/linux/irqchip/irq-st.h

Copy & Paste?

Can we please stop adding these pointless filenames all over the
place? They are useless and wrong in a lot of cases.

Aside of that, this needs an ack from the DT folks.

Thanks,

	tglx
