Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab3BSO7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:59:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45833 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab3BSO7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:59:51 -0500
Date: Tue, 19 Feb 2013 15:59:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v8] AMD64 EDAC: Fix type usage in NB IDs and memory
 ranges
Message-ID: <20130219145947.GK26623@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com>
 <1354265060-22956-2-git-send-email-daniel@numascale-asia.com>
 <20121130171749.GB23034@liondog.tnic>
 <50BDC140.8060004@numascale-asia.com>
 <20121204160156.GH4369@liondog.tnic>
 <51238EDA.7060700@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51238EDA.7060700@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 10:40:26PM +0800, Daniel J Blueman wrote:
> Alas your merges missed the v3.8 merge window, but it looks like your
> v3.9 pull request has dropped these patches [1].
>
> Any chance you can get them in during this merge window?

They should go in anytime now. They're in tip:x86/platform and Ingo is
sending pull requests to Linus as we speak. Since they touch x86 code I
asked x86 guys to send them upstream instead of me.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
