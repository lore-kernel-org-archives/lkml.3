Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3JQRxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:53:07 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:40250 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3JQRxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:53:05 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Kukjin Kim <kgene@kernel.org>,
        "'Chander Kashyap'" <chander.kashyap@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        tglx@linutronix.de, thomas.abraham@linaro.org, t.figa@samsung.com
Subject: Re: [PATCH v2] irqchip: exynos-combiner: remove hard-coded irq_base value
Date: Thu, 17 Oct 2013 10:53:02 -0700 (PDT)
Message-ID: <1949846.N3fAUHQ1Nx@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <02c701ceba75$f95b1900$ec114b00$@org>
References: <1379937815-21746-1-git-send-email-chander.kashyap@linaro.org> <02c701ceba75$f95b1900$ec114b00$@org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On Thursday 26 of September 2013 14:05:09 Kukjin Kim wrote:
> Chander Kashyap wrote:
> > Replace irq_domain_add_simple with "irq_domain_add_linear" in order to
> > use linear irq domain, and to remove hardcoded irq_base_value.
> > 
> > Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> > ---
> > 
> > Changes since v1:
> > 	- Replaced irq_domain_add_simple with irq_domain_add_linear,
> > 	
> > 	  as suggested by Tomasz
> >  
> >  drivers/irqchip/exynos-combiner.c |   15 +++------------
> >  1 file changed, 3 insertions(+), 12 deletions(-)
[snip]
> 
> Looks nice to me, applied with Tomasz's review.

I don't see this patch in your tree. Did you apply it in the end?

Best regards,
Tomasz

