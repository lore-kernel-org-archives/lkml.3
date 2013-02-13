Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab3BMQj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:39:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48703 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759377Ab3BMQj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:39:56 -0500
Date: Wed, 13 Feb 2013 17:39:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] fix 32-bit compile warning from printk()
Message-ID: <20130213163948.GB26948@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, KVM <kvm@vger.kernel.org>
References: <20130128191939.7F67966B@kernel.stglabs.ibm.com>
 <511BBFC4.7090601@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <511BBFC4.7090601@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 08:31:00AM -0800, Randy Dunlap wrote:
> This warning is still present in linux-next (20130213).
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Thanks.
> 
> Someone please merge...  (kvm@ cc added)

There's a fix already in tip for this:

http://git.kernel.org/tip/136867f517cbc3f8a91f035677911a6b503c3323

which needs to change again once the %pa printk stuff get merged.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
