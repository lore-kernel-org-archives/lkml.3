Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3LPBvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 20:51:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab3LPBvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 20:51:45 -0500
Date: Mon, 16 Dec 2013 09:50:50 +0800
From: Dave Young <dyoung@redhat.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Mark Salter <msalter@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH v5 02/14] efi: use early_memremap and early_memunmap
Message-ID: <20131216015049.GB3754@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-3-git-send-email-dyoung@redhat.com>
 <20131211103903.GC19196@console-pimps.org>
 <20131211110227.GK22356@rocoto.smurfnet.nu>
 <20131211113207.GA29980@console-pimps.org>
 <1386775078.1979.98.camel@deneb.redhat.com>
 <20131213155133.GR22356@rocoto.smurfnet.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213155133.GR22356@rocoto.smurfnet.nu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/13 at 04:51pm, Leif Lindholm wrote:
> On Wed, Dec 11, 2013 at 10:17:58AM -0500, Mark Salter wrote:
> > Anyway, I posted a patch to create a generic early_ioremap
> > implementation using generic bits of the x86 code:
> > 
> >   https://lkml.org/lkml/2013/11/27/621
> > 
> > So maybe Dave's patch 1/14 should be part of that series or
> > get rebased on top of it.
> 
> Yes, having those two sets of changes to the same bits floating around
> at the same time is painful.
> If you could integrate those changes into your set, everyone wins.

I have no idea how to handle these dependency problems between different
patchset, but for this one I feel it's better to add it to Mark's series,
what's the status of the series, has it been reviewed and ready for merge?

--
Thanks
Dave
