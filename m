Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3J3CEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:04:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3J3CEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:04:38 -0400
Date: Wed, 30 Oct 2013 10:03:49 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Message-ID: <20131030020348.GA4332@dhcp-16-126.nay.redhat.com>
References: <20131028094049.GC25527@dhcp-16-126.nay.redhat.com>
 <20131028095117.GD25527@dhcp-16-126.nay.redhat.com>
 <20131028100402.GC4314@pd.tnic>
 <20131028101011.GF25527@dhcp-16-126.nay.redhat.com>
 <20131028112045.GH4314@pd.tnic>
 <20131028112458.GD29133@dhcp-16-126.nay.redhat.com>
 <20131028145801.GM4314@pd.tnic>
 <20131028151048.GA14984@dhcp-16-126.nay.redhat.com>
 <20131029023203.GB5185@dhcp-16-126.nay.redhat.com>
 <20131029134302.GI10972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029134302.GI10972@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 at 02:43pm, Borislav Petkov wrote:
> On Tue, Oct 29, 2013 at 10:32:03AM +0800, Dave Young wrote:
> > I remember I tried your efi branch, but the code is different from
> > what you sent to list, thus I turned to use the mbox patches.
> 
> Yeah, please use the #efi branch as I keep refreshing it with the newest
> changes. They're hopefully not serious changes but minor stuff here and
> there so basing stuff ontop should be ok.

Will try, but please keep the posted patches in mailing list up-to-date,
I'm an old-fashioned person, do not tend to depend on git.

Thanks in advance.
Dave
