Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3LMPvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:51:22 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:60134 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab3LMPvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:51:19 -0500
Date: Fri, 13 Dec 2013 16:51:33 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, Dave Young <dyoung@redhat.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH v5 02/14] efi: use early_memremap and early_memunmap
Message-ID: <20131213155133.GR22356@rocoto.smurfnet.nu>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-3-git-send-email-dyoung@redhat.com>
 <20131211103903.GC19196@console-pimps.org>
 <20131211110227.GK22356@rocoto.smurfnet.nu>
 <20131211113207.GA29980@console-pimps.org>
 <1386775078.1979.98.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386775078.1979.98.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 10:17:58AM -0500, Mark Salter wrote:
> Anyway, I posted a patch to create a generic early_ioremap
> implementation using generic bits of the x86 code:
> 
>   https://lkml.org/lkml/2013/11/27/621
> 
> So maybe Dave's patch 1/14 should be part of that series or
> get rebased on top of it.

Yes, having those two sets of changes to the same bits floating around
at the same time is painful.
If you could integrate those changes into your set, everyone wins.

/
    Leif
