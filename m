Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaB1WRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:17:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbaB1WRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:17:00 -0500
Message-ID: <1393625813.2817.1.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
From: Adam Williamson <awilliam@redhat.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com
Date: Fri, 28 Feb 2014 14:16:53 -0800
In-Reply-To: <53110977.8080907@linux.intel.com>
References: <53100C8D.1060001@linux.intel.com>
	 <20140228045637.GA28257@srcf.ucam.org> <53101D1D.9010202@linux.intel.com>
	 <20140228055629.GA847@srcf.ucam.org> <531027BE.2010807@linux.intel.com>
	 <20140228061254.GA2226@srcf.ucam.org> <53102AB9.40600@linux.intel.com>
	 <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com>
	 <20140228064413.GA4900@srcf.ucam.org> <531032A0.8090903@linux.intel.com>
	 <5310CBB7.4030407@linux.intel.com> <53110977.8080907@linux.intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-01 at 06:11 +0800, Li, Aubrey wrote:
> On 2014/3/1 1:47, H. Peter Anvin wrote:
> > On 02/27/2014 10:54 PM, Li, Aubrey wrote:
> >> On 2014/2/28 14:44, Matthew Garrett wrote:
> >>> On Fri, Feb 28, 2014 at 02:39:56PM +0800, Li, Aubrey wrote:
> >>>
> >>>> Just let you know, Windows8.1 calls EFI on these boxes for reboot/shutdown.
> >>>
> >>> Ok, in that case we should add EFI reboot to the list once Matt's 1:1 
> >>> mapping support has landed. The right place to try it is probably after 
> >>> the second attempt to perform an ACPI reboot. I'm still not enthusiastic 
> >>> about adding cf9 by default.
> >>>
> >>
> >> I'll defer to you if no one on the list supports me to add cf9.
> >>
> > 
> > I believe we *had* it in the default list for a while, and it caused
> > hangs on some systems.
> 
> So this can be finalized, add EFI after twice ACPI reboot attempt. I'll
> update the bugzilla and the patch.
> 
> Thanks,
> -Aubrey

I believe Matt still wanted to check the status of "the recent patches
to provide a 1:1 mapping" and only commit this after those. I was trying
to figure out what patches he meant exactly so I could check that status
(I'm helping! I'm helping!) but I couldn't.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

