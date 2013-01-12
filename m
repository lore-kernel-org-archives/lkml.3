Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3ALRky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:40:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33647 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab3ALRkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:40:53 -0500
Message-ID: <50F1A004.4090200@zytor.com>
Date: Sat, 12 Jan 2013 09:40:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, David Woodhouse <dwmw2@infradead.org>,
        mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, David.Woodhouse@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86: Default to ARCH= x86 to avoid overriding
 CONFIG_64BIT
References: <1356040315.3198.51.camel@shinybook.infradead.org> <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org> <20130112170647.GA10659@liondog.tnic>
In-Reply-To: <20130112170647.GA10659@liondog.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2013 09:06 AM, Borislav Petkov wrote:
> 
> Ok, I don't know whether this was on purpose or not but setting ARCH=x86
> has the side effect of putting the config 64BIT prompt into the toplevel
> menuconfig:
> 
> 	[*] 64-bit kernel
> 	    General setup  --->
> 	[*] Enable loadable module support  --->
> 	[*] Enable the block layer  --->
> 	    Processor type and features  --->
> 
> Now, IMHO, maybe the more fitting place for this should be "Processor
> type and features" where all the arch-specific stuff goes but looking at
> arch/x86/Kconfig, it would need some restructuring due to dependencies.
> 
> So how about we simply hide it by still preserving the functionality:
> 

Hiding it because it happens to be in a slightly illogical place seems
completely backwards.

	-hpa


