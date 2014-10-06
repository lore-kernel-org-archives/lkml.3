Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaJFVLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:11:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53609 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaJFVLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:11:17 -0400
Date: Mon, 6 Oct 2014 23:11:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] edac, amd64_edac: Add F15h M60h support
Message-ID: <20141006211113.GG20739@pd.tnic>
References: <1411070230-10298-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141001113235.GC18271@pd.tnic>
 <542C1EAA.4050408@amd.com>
 <20141001154523.GF18271@pd.tnic>
 <542EB53E.30507@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <542EB53E.30507@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 09:39:58AM -0500, Aravind Gopalakrishnan wrote:
> So it seems we can theoretically have systems in this manner, but that is
> not a common case..
> 
> So, shall I just use first DCSM to keep it simple for now?
> And find rank multiplier iteratively as and when need arises?

Yep, sounds nicely conservative.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
