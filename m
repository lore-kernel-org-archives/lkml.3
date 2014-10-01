Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaJAQLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:11:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33365 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbaJAQLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:11:41 -0400
Date: Wed, 1 Oct 2014 18:11:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] edac, amd64_edac: Add F15h M60h support
Message-ID: <20141001161135.GG18271@pd.tnic>
References: <1411070230-10298-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141001113235.GC18271@pd.tnic>
 <542C1EAA.4050408@amd.com>
 <20141001154523.GF18271@pd.tnic>
 <542C2588.2040004@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <542C2588.2040004@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 11:02:16AM -0500, Aravind Gopalakrishnan wrote:
> Not AFAIK, But I'll ask to make sure.

Yes please.

> If different LRDIMMs on one DCT don't exist, then sure, I'll modify the code
> to use first DCSM.

Right.

> Regarding resend-
> I'm not sure how you'll want the patches.. I just noticed a 'edac-for-3.19'
> branch.

I uploaded it for the 0day bot so that the patches can be build-tested a
little with different configs. Don't pay attention to any other branches
except to "for-next" which is what will go to Linus come next merge
window. The other branches might get rebased and you shouldn't base any
work ontop.

> Would you prefer I based changes on top of this for merging purposes?
> Or just resend the original 4 patches based off tip as usual?

Nah, just resend the last one - 4/4 - the other three are fine.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
