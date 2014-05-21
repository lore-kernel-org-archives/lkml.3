Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaEUP2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:28:54 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:55669 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbaEUP2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:28:52 -0400
Message-ID: <1400686086.856.15.camel@iivanov-dev>
Subject: Re: [PATCH v1 4/4] ARM: debug: qcom: Add APQ8084 DEBUG_LL UART
 support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Georgi Djakov <gdjakov@mm-sol.com>, linux@arm.linux.org.uk,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sboyd@codeaurora.org, rvaswani@codeaurora.org, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Wed, 21 May 2014 18:28:06 +0300
In-Reply-To: <4365639.JcFl1cP048@wuerfel>
References: <1400684225-21381-1-git-send-email-gdjakov@mm-sol.com>
	 <1400684225-21381-5-git-send-email-gdjakov@mm-sol.com>
	 <4365639.JcFl1cP048@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

On Wed, 2014-05-21 at 17:18 +0200, Arnd Bergmann wrote:
> On Wednesday 21 May 2014 17:57:05 Georgi Djakov wrote:

> >  
> > +#ifdef CONFIG_DEBUG_APQ8084_UART
> > +#define MSM_DEBUG_UART_BASE    0xFA75E000
> > +#define MSM_DEBUG_UART_PHYS    0xF995E000
> > +#endif
> > +

> Maybe we should move debug/msm.S over to use
> CONFIG_DEBUG_UART_PHYS/CONFIG_DEBUG_UART_VIRT now?
> 

There is patch which do this [1]. It was reviewed 
by Stephen Boyd [2].

Regards,
Ivan


[1] https://lkml.org/lkml/2014/4/14/312
[2] https://lkml.org/lkml/2014/4/14/542



