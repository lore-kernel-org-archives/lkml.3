Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaE1RXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:23:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50743 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbaE1RXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:23:52 -0400
Date: Wed, 28 May 2014 19:23:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: Chen Yucong <slaoub@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC PATCH 0/3] RAS: Correctable Errors Collector thing
Message-ID: <20140528172347.GG17196@pd.tnic>
References: <1401197235-13440-1-git-send-email-bp@alien8.de>
 <1401245361.5049.6.camel@cyc>
 <1401296015.4361.12.camel@oc3432500282.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401296015.4361.12.camel@oc3432500282.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 09:53:35AM -0700, Max Asbock wrote:
> A possible alternative would be to soft-offline the page. This is
> currently done in APEI code when corrected memory error thresholds are
> exceeded and reported by UEFI via a generic hardware error source
> (GHES). 
> The example is in ghes_handle_memory_failure() where we call
> memory_failure_queue(pfn, 0, flags) with flags = MF_SOFT_OFFLINE

Ok, we can try that - it certainly makes sense. We're designing the
plumbing of this thing as we go so fitting it correctly into the whole
reporting/error handling chain is still open. It is RFC anyway so...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
