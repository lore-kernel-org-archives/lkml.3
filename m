Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3KUPy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:54:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34232 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab3KUPy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:54:56 -0500
Date: Thu, 21 Nov 2013 16:54:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 1/9 v3] efi: remove unused variables in __map_region
Message-ID: <20131121155448.GJ26009@pd.tnic>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061752.715177297@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131121061752.715177297@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:17:05PM +0800, dyoung@redhat.com wrote:
> variables size and end is useless in this function, thus remove them.
> 
> Reported-by: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Dave Young <dyoung@redhat.com>

Good catch.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
