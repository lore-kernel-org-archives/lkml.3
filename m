Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3JaCIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 22:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3JaCIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 22:08:51 -0400
Date: Thu, 31 Oct 2013 10:07:14 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Message-ID: <20131031020714.GB4377@dhcp-16-126.nay.redhat.com>
References: <20131028101011.GF25527@dhcp-16-126.nay.redhat.com>
 <20131028112045.GH4314@pd.tnic>
 <20131028112458.GD29133@dhcp-16-126.nay.redhat.com>
 <20131028145801.GM4314@pd.tnic>
 <20131028151048.GA14984@dhcp-16-126.nay.redhat.com>
 <20131029023203.GB5185@dhcp-16-126.nay.redhat.com>
 <20131029134302.GI10972@pd.tnic>
 <20131030020348.GA4332@dhcp-16-126.nay.redhat.com>
 <20131030104718.GB13290@pd.tnic>
 <20131031020405.GA4377@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031020405.GA4377@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/13 at 10:04am, Dave Young wrote:
> On 10/30/13 at 11:47am, Borislav Petkov wrote:
> > On Wed, Oct 30, 2013 at 10:03:49AM +0800, Dave Young wrote:
> > > Will try, but please keep the posted patches in mailing list up-to-date,
> > 
> > Would you like me to send them to you privately?
> 
> Thanks, do not bother to send me privately I can get it from your git tree.
> 
> But Frankly I'd like to see them in list instead even with only small fixes
> beacuse in this way there might be more people to review it carefully.

There's another shorcoming for keeping new patches in git is that nobody know
when you push it and when is the proper date to pull from your git. I think
it's better to use git only for the patches which have already been accepted
and is waiting for maintainer to pull.

> 
> --
> Thanks
> Dave
