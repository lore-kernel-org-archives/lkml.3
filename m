Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbaKSVyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:54:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47108 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274AbaKSVx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:53:57 -0500
Date: Wed, 19 Nov 2014 22:53:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Chen Yucong <slaoub@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        aravind.gopalakrishnan@amd.com,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/2]RAS: add the support for handling UCNA/DEFERRED
 error
Message-ID: <20141119215354.GC4102@pd.tnic>
References: <1416276560-3363-1-git-send-email-slaoub@gmail.com>
 <CA+8MBbJ-Vs_h2LXoVuzPmbTLsAGThhHR7UxoA56gNt4Lmjy27g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbJ-Vs_h2LXoVuzPmbTLsAGThhHR7UxoA56gNt4Lmjy27g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 01:44:28PM -0800, Tony Luck wrote:
> I've put these in a "ucna" branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git
> 
> Boris - have you had a chance to research how to fill in the AMD TBD section
> yet?  Or should I just ask Ingo to pull this into tip now to be fixed later?

I'm working on the details and will have the final patch soon. But don't
let me stop you - I'll send the patch afterwards against that branch if
x86 guys pull in the meantime.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
