Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab3GSTf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:35:56 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:20322 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3GSTfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:35:54 -0400
Message-ID: <1374262502.24916.177.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
From: Toshi Kani <toshi.kani@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, dave@sr71.net,
        isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Date: Fri, 19 Jul 2013 13:35:02 -0600
In-Reply-To: <51E993D5.2080409@gmail.com>
References: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
	 <51E993D5.2080409@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 15:30 -0400, KOSAKI Motohiro wrote:
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index b32ebf9..408ef68 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1344,8 +1344,13 @@ config ARCH_SELECT_MEMORY_MODEL
> >   	depends on ARCH_SPARSEMEM_ENABLE
> >   
> >   config ARCH_MEMORY_PROBE
> > -	def_bool y
> > +	bool "Enable sysfs memory/probe interface"
> > +	default n
> >   	depends on X86_64 && MEMORY_HOTPLUG
> > +	help
> > +	  This option enables a sysfs memory/probe interface for testing.
> > +	  See Documentation/memory-hotplug.txt for more information.
> > +	  If you are unsure how to answer this question, answer N.
> 
> makes sense.
> 
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Great!  Thanks Motohiro!
-Toshi


