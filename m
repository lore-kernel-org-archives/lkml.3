Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935448Ab3DJNc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:32:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41222 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab3DJNcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:32:55 -0400
Date: Wed, 10 Apr 2013 15:32:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] x86: FPU detection in C
Message-ID: <20130410133251.GC6857@pd.tnic>
References: <1365436666-9837-1-git-send-email-bp@alien8.de>
 <20130410110840.GA29752@gmail.com>
 <20130410122411.GE13394@pd.tnic>
 <20130410122527.GB8686@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130410122527.GB8686@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(let's test the reply-to-all settings now :-))

On Wed, Apr 10, 2013 at 02:25:27PM +0200, Ingo Molnar wrote:
> In my builds I disable that. So I'd suggest to disable that bit in the
> .config and retry.

Yep, did that and was able to reproduce the issue in qemu. At a first
glance, it looks like we're calling kmalloc too early but I need to
verify this is actually the case. Stay tuned.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
