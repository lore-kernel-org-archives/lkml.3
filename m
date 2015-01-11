Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbbAKAHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 19:07:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56004 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbbAKAHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 19:07:14 -0500
Date: Sun, 11 Jan 2015 01:07:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Joe Perches <joe@perches.com>, Steven Honeyman <stevenhoneyman@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/kernel/cpu/common.c: split log entry into
 logical components
Message-ID: <20150111000709.GL12218@pd.tnic>
References: <alpine.DEB.2.11.1501102203380.2303@localhost.localdomain>
 <1420929338.16787.6.camel@perches.com>
 <alpine.DEB.2.11.1501102345590.26282@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501102345590.26282@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 11:57:04PM +0000, Scot Doyle wrote:
> Steven, are you planning to resubmit the patch as suggested by Borislav?

I think he did resubmit:

https://lkml.kernel.org/r/1415227938-16927-1-git-send-email-stevenhoneyman@gmail.com

but it seems it has been forgotten. I'll pick it up.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
