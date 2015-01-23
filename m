Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbbAWQjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:39:46 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:46452 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbbAWQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:39:44 -0500
Date: Fri, 23 Jan 2015 16:39:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 1/8] dt: bindings: Supply shared ST IRQ defines
Message-ID: <20150123163938.GC11745@x1>
References: <1421920133-7914-1-git-send-email-lee.jones@linaro.org>
 <1421920133-7914-2-git-send-email-lee.jones@linaro.org>
 <alpine.DEB.2.11.1501231656310.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.11.1501231656310.5526@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Thomas Gleixner wrote:

> On Thu, 22 Jan 2015, Lee Jones wrote:
> 
> > These defines are used to allow values used for configuration to be
> > easily human readable and will lessen the chance of logical mistakes.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  include/dt-bindings/interrupt-controller/irq-st.h | 30 +++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >  create mode 100644 include/dt-bindings/interrupt-controller/irq-st.h
> > 
> > diff --git a/include/dt-bindings/interrupt-controller/irq-st.h b/include/dt-bindings/interrupt-controller/irq-st.h
> > new file mode 100644
> > index 0000000..4c59ace
> > --- /dev/null
> > +++ b/include/dt-bindings/interrupt-controller/irq-st.h
> > @@ -0,0 +1,30 @@
> > +/*
> > + *  include/linux/irqchip/irq-st.h
> 
> Copy & Paste?
> 
> Can we please stop adding these pointless filenames all over the
> place? They are useless and wrong in a lot of cases.

Less of a copy and paste and more and a `mv` without fixing up the
file names.  I guess they are silly, but they are rife, so someone must
think they're a good idea. :)

  for file in `find drivers -name *.c`; do head $file | grep "\.c$"; done

> Aside of that, this needs an ack from the DT folks.

I think you'll be lucky.  I haven't seen a DT review for some time
now.  Perhaps, as it's you, this might be different. ;)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
