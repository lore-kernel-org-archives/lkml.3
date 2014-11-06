Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaKFJkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 04:40:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37909 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbaKFJkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 04:40:10 -0500
Date: Thu, 6 Nov 2014 10:40:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] x86: Drop redundant memory-block sizing code
Message-ID: <20141106094007.GA4849@pd.tnic>
References: <ojh5M-xh-17@gated-at.bofh.it>
 <1415249414-20888-1-git-send-email-daniel@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415249414-20888-1-git-send-email-daniel@numascale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 12:50:14PM +0800, Daniel J Blueman wrote:
> Drop the unused code from selecting a fixed memory block size of 2GB
> on large-memory x86-64 systems.
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale.com>

This commit message is seriously lacking an explanation why? Why is it
unused, why is it ok on systems with mem < 64g, what is the problem it
solves, ...

Just ask yourself this when you write commit messages: would anyone else
be able to understand what this commit was improving when anyone reads
that commit message months, maybe years from now.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
