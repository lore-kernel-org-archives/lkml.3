Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaFZVVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:21:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55999 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaFZVV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:21:29 -0400
Date: Thu, 26 Jun 2014 23:21:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
        hpa@zytor.com
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, mjg59@srcf.ucam.org, greg@kroah.com,
        dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com
Subject: Re: [PATCH 00/15][V4] kexec: A new system call to allow in kernel
 loading
Message-ID: <20140626212122.GD1284@pd.tnic>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <20140626135811.37c10ff327bea8a9d2e3894e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140626135811.37c10ff327bea8a9d2e3894e@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 01:58:11PM -0700, Andrew Morton wrote:
> Well, this is an absolute ton of new code, much of it pretty complex.
> And I believe the entire point of this work is to enable image
> signature checking, but that hasn't been implemented yet?
>
> In which case I'm thinking it would be unwise to merge these parts
> into mainline - if signature checking doesn't work or fails review or
> if you get hit by a bus then we'd be left with a large lump of rather
> useless code?
>
> In which case I'm inclined to put this series into -next and keep it
> there pending completion of the signature checking part.

Before we rush these in, it'd be nice if someone more experienced would
take a look at the general approach of the whole handling with the
purgatory and such. I certainly tried to give my best while reviewing
but I'm too inexperienced in kexec and the whole booting of another
kernel and all the intricacies of the process. It'll be optimal if Eric
Biederman would find some free time for those.

AFAIK, hpa wanted to take a look too so can we please slow down a bit
here first?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
