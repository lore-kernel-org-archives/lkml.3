Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab3K2RCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:02:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45191 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab3K2RCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:02:45 -0500
Date: Fri, 29 Nov 2013 18:02:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 00/12] kexec kernel efi runtime support
Message-ID: <20131129170235.GG4266@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <20131127125003.GG18170@console-pimps.org>
 <20131128020840.GB4282@dhcp-16-126.nay.redhat.com>
 <20131129082822.GA4186@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131129082822.GA4186@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 04:28:22PM +0800, Dave Young wrote:
> I think for anyone who are using early_memremap should know this is a
> normal kernel memory instead of real __iomem

You can never ever assume that people are using kernel interfaces
correctly.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
