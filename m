Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbaDBJBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:01:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42806 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758126AbaDBJBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:01:46 -0400
Date: Wed, 2 Apr 2014 11:01:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: William Dauchy <wdauchy@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        "tglx@linutronix.de" <tglx@linutronix.de>, Tony <tony.luck@intel.com>,
        Gong <gong.chen@linux.intel.com>, linux-tip-commits@vger.kernel.org,
        William Dauchy <william@gandi.net>
Subject: Re: [tip:x86/urgent] x86, CMCI: Add proper detection of end of CMCI
 storms
Message-ID: <20140402090132.GA16033@pd.tnic>
References: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org>
 <CAJ75kXZbvs2mGRQod0df5Xs_AcodsQ=n+030tYawQDrFW01Y2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJ75kXZbvs2mGRQod0df5Xs_AcodsQ=n+030tYawQDrFW01Y2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 10:51:49AM +0200, William Dauchy wrote:
> Could you use the following address instead?
> Reported-by: William Dauchy <william@gandi.net>

It is too late for that now as the patch is in -tip already... Unless
Ingo can still amend it, that is.

But, we're working on a real solution for the storm issue and there
we'll be asking you to test stuff anyway so we'll make sure to use this
mail address then, ok?

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
