Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaAPDDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:03:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaAPDDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:03:38 -0500
Date: Thu, 16 Jan 2014 11:03:43 +0800
From: Dave Young <dyoung@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Message-ID: <20140116030343.GF3807@dhcp-16-126.nay.redhat.com>
References: <20140113053240.GA11237@dhcp-16-126.nay.redhat.com>
 <20140113101822.GA5388@pd.tnic>
 <20140113122320.GA1900@darkstar.nay.redhat.com>
 <52D3FCAA.7070004@linux.intel.com>
 <20140114014003.GB4327@dhcp-16-126.nay.redhat.com>
 <52D57F75.7060308@zytor.com>
 <20140115011609.GD23767@dhcp-16-126.nay.redhat.com>
 <52D6970D.3050701@zytor.com>
 <20140116014457.GA3807@dhcp-16-126.nay.redhat.com>
 <52D746D9.7030206@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D746D9.7030206@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/14 at 06:41pm, Arjan van de Ven wrote:
> On 1/15/2014 5:44 PM, Dave Young wrote:
> >On 01/15/14 at 06:11am, H. Peter Anvin wrote:
> >>On 01/14/2014 05:16 PM, Dave Young wrote:
> >>>>
> >>>>Why the [Finnish] do you feel that information needs to be in a
> >>>>different form because it is (currently!) not available as a module?
> >>>
> >>>I think moving them to comment can avoid including extra linux/module.h
> >>>
> >>
> >>And that matters, why?
> >
> >At least the code will be cleaner and kernel size will be a bit smaller?
> >
> 
> making something harder to grep and less standardized is hardly cleaner
> and these things compile to nothing for non-modules.

It's not nothing, just very small increasement:
   text	   data	    bss	    dec	    hex	filename
7636121	1391824	9355264	18383209	1188169	vmlinux

   text	   data	    bss	    dec	    hex	filename
7636113	1391824	9355264	18383201	1188161	vmlinux

I do not want to insist on this minor problem, if you want please keep it.

Thanks
Dave
