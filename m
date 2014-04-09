Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbaDIOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:16:58 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:36857 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761AbaDIOQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:16:56 -0400
Message-ID: <1397052954.22858.30.camel@iivanov-dev>
Subject: Re: [PATCH] ARM: msm: Make MSM_HAS_DEBUG_UART_HS option visible to
 multiplatform targets
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Wed, 09 Apr 2014 17:15:54 +0300
In-Reply-To: <53455268.4030003@codeaurora.org>
References: <1397048912-6738-1-git-send-email-iivanov@mm-sol.com>
	 <53455268.4030003@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 10:00 -0400, Christopher Covington wrote:
> Hi Ivan,
> 
> On 04/09/2014 09:08 AM, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > High Speed UART is available also in new multiplatform QCOM targets.
> 
> > diff --git a/arch/arm/include/debug/msm.S b/arch/arm/include/debug/msm.S
> > index 9d653d4..09ff7b7 100644
> > --- a/arch/arm/include/debug/msm.S
> > +++ b/arch/arm/include/debug/msm.S
> > @@ -39,11 +39,14 @@
> >  #ifdef CONFIG_DEBUG_MSM8660_UART
> >  #define MSM_DEBUG_UART_BASE	0xF0040000
> >  #define MSM_DEBUG_UART_PHYS	0x19C40000
> > +#define MSM_HAS_DEBUG_UART_HS
> >  #endif
> > 
> >  #ifdef CONFIG_DEBUG_MSM8960_UART
> > +#define MSM_HAS_DEBUG_UART_HS
> 
> This appears to be duplicated.

Ops, right. Will send fixed version.

Thanks,
Ivan

> 
> >  #define MSM_DEBUG_UART_BASE	0xF0040000
> >  #define MSM_DEBUG_UART_PHYS	0x16440000
> > +#define MSM_HAS_DEBUG_UART_HS
> >  #endif
> > 
> >  #ifdef CONFIG_DEBUG_MSM8974_UART
> 
> Regards,
> Christopher
> 


