Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3JaKok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:44:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3JaKoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:44:38 -0400
Date: Thu, 31 Oct 2013 11:44:26 +0100
From: Borislav Petkov <bp@suse.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Message-ID: <20131031104426.GA10544@pd.tnic>
References: <20131028112045.GH4314@pd.tnic>
 <20131028112458.GD29133@dhcp-16-126.nay.redhat.com>
 <20131028145801.GM4314@pd.tnic>
 <20131028151048.GA14984@dhcp-16-126.nay.redhat.com>
 <20131029023203.GB5185@dhcp-16-126.nay.redhat.com>
 <20131029134302.GI10972@pd.tnic>
 <20131030020348.GA4332@dhcp-16-126.nay.redhat.com>
 <20131030104718.GB13290@pd.tnic>
 <20131031020405.GA4377@dhcp-16-126.nay.redhat.com>
 <20131031020714.GB4377@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131031020714.GB4377@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Young,

On Thu, Oct 31, 2013 at 10:07:14AM +0800, Dave Young wrote:
> > But Frankly I'd like to see them in list instead even with only small fixes
> > beacuse in this way there might be more people to review it carefully.
> 
> There's another shorcoming for keeping new patches in git is that nobody know
> when you push it and when is the proper date to pull from your git. I think
> it's better to use git only for the patches which have already been accepted
> and is waiting for maintainer to pull.

thank you for teaching me how to do kernel development!

The actual and real reason why I didn't send them yet is because I
didn't want to be that kaffeine-inflated dork who spams the lists every
other day with a new version of his patches.

I am running build smoketests now and will send the latest version of
the patchset later today so don't worry, the world will see them :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
