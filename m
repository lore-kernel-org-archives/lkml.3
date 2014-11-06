Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaKFKkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:40:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42257 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaKFKkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:40:39 -0500
Date: Thu, 6 Nov 2014 11:40:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] x86: Drop redundant memory-block sizing code
Message-ID: <20141106104034.GB4849@pd.tnic>
References: <ojh5M-xh-17@gated-at.bofh.it>
 <1415249414-20888-1-git-send-email-daniel@numascale.com>
 <20141106094007.GA4849@pd.tnic>
 <545B4E84.7050707@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <545B4E84.7050707@numascale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 06:33:40PM +0800, Daniel J Blueman wrote:
> As the first check for 64GB or larger memory returns a 2GB memory block size
> in that case, the following check for less than 64GB will always evaluate
> true, leading to unreachable code.

I'm reading this as this code is never running on systems < 64GB. Why is
that so?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
