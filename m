Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbaDBKwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:52:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57591 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052AbaDBKwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:52:17 -0400
Date: Wed, 2 Apr 2014 12:52:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: William Dauchy <wdauchy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        hpa@zytor.com, "tglx@linutronix.de" <tglx@linutronix.de>,
        Tony <tony.luck@intel.com>, Gong <gong.chen@linux.intel.com>,
        linux-tip-commits@vger.kernel.org, William Dauchy <william@gandi.net>
Subject: Re: [tip:x86/urgent] x86, CMCI: Add proper detection of end of CMCI
 storms
Message-ID: <20140402105202.GD16025@pd.tnic>
References: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org>
 <CAJ75kXZbvs2mGRQod0df5Xs_AcodsQ=n+030tYawQDrFW01Y2Q@mail.gmail.com>
 <20140402090132.GA16033@pd.tnic>
 <20140402104612.GA26844@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140402104612.GA26844@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 12:46:12PM +0200, Ingo Molnar wrote:
> There are already patches on top of it, so it's not possible - but
> even if it was the last one, since it got committed by Tony I cannot
> rebase or amend it.

Ah right, you pulled it from him, sure.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
