Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab3EWUJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:09:45 -0400
Received: from relais.videotron.ca ([24.201.245.36]:25979 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310Ab3EWUJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:09:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 23 May 2013 16:09:40 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v7] arm: use built-in byte swap function
In-reply-to: <20130523114654.1f273241725205c6703b2226@freescale.com>
Message-id: <alpine.LFD.2.03.1305231607060.1918@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
 <alpine.LFD.2.02.1302082102380.6300@xanadu.home>
 <20130219203115.114eab79e8d2099c6306d921@freescale.com>
 <alpine.LFD.2.03.1302192151280.6419@syhkavp.arg>
 <1361356696.13482.269.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302200835380.6419@syhkavp.arg>
 <1361367842.13482.279.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302200905300.6419@syhkavp.arg>
 <1361372008.13482.280.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302201040460.6419@syhkavp.arg>
 <20130220214943.9b28a5b208da9f081387c55e@freescale.com>
 <alpine.LFD.2.03.1302202327370.6419@syhkavp.arg>
 <20130221005221.15279b1372501af12c1e4f32@freescale.com>
 <alpine.LFD.2.03.1302211134160.6419@syhkavp.arg>
 <20130221203327.6558f89277468f7ffffa6506@freescale.com>
 <alpine.LFD.2.03.1302212219100.6419@syhkavp.arg>
 <20130222194032.f7b44aefa5e2723d16767a1b@freescale.com>
 <1361661654.18110.102.camel@shinybook.infradead.org>
 <20130523114654.1f273241725205c6703b2226@freescale.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May 2013, Kim Phillips wrote:

> Enable the compiler intrinsic for byte swapping on arch ARM.  This
> allows the compiler to detect and be able to optimize out byte
> swappings, and has a very modest benefit on vmlinux size (Linaro gcc
> 4.8):
> 
>    text	   data	    bss	    dec	    hex	filename
> 2840310	 123932	  61960	3026202	 2e2d1a	vmlinux-lart #orig
> 2840152	 123932	  61960	3026044	 2e2c7c	vmlinux-lart #builtin-bswap
> 
> 6473120	 314840	5616016	12403976 bd4508	vmlinux-mxs #orig
> 6472586	 314848	5616016	12403450 bd42fa	vmlinux-mxs #builtin-bswap
> 
> 7419872	 318372	 379556	8117800	 7bde28	vmlinux-imx_v6_v7 #orig
> 7419170	 318364	 379556	8117090	 7bdb62	vmlinux-imx_v6_v7 #builtin-bswap
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
> Acked-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
> resending as v6 appears to have fallen though the cracks.  Russell?

Please send your patch to Russell's patch system:

http://www.arm.linux.org.uk/developer/patches/


Nicolas
