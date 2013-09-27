Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab3I0Fv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:51:57 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:53576 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3I0Fvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:51:55 -0400
Date: Fri, 27 Sep 2013 07:51:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, msharbiani@twitter.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/reboot] x86/reboot: Remove the duplicate C6100 entry in
 the reboot quirks list
Message-ID: <20130927055151.GD6597@gmail.com>
References: <1380216643-4683-1-git-send-email-masoud.sharbiani@gmail.com>
 <tip-b5eafc6f07c95e9f3dd047e72737449cb03c9956@git.kernel.org>
 <1380229154.2170.13.camel@buesod1.americas.hpqcorp.net>
 <5244A0E2.3080902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5244A0E2.3080902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 09/26/2013 01:59 PM, Davidlohr Bueso wrote:
> >> -	},
> >> -	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
> >> -		.callback = set_pci_reboot,
> >> -		.ident = "Dell PowerEdge C6100",
> >> -		.matches = {
> >>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
> >>  			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
> >>  		},
> > 
> > Hmm, I think we should be keeping the 'Dell Inc.' part instead of just
> > 'Dell' - at least the rest of the entries use the same string:
> > 
> 
> The point is that some of the machines just has "Dell" in their vendor
> string.

Yes, so if then the argument could be made that all the other entries 
should probably be changed to 'Dell' as well.

This is yet another reminder that DMI matches are such a fragile method 
...

Thanks,

	Ingo
