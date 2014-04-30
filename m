Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbaD3RQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:16:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34247 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759258AbaD3RQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:16:45 -0400
Date: Wed, 30 Apr 2014 19:16:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Lutomriski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] x86-64, espfix: Don't leak bits 31:16 of %esp returning
 to 16-bit stack
Message-ID: <20140430171640.GB17723@pd.tnic>
References: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
 <20140430103822.GD23736@pd.tnic>
 <536125F3.9050807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <536125F3.9050807@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 09:33:55AM -0700, H. Peter Anvin wrote:
> Heh. I think I might have used the wrong one, though... GPLv2+ vs
> GPLv2.

Why is GPLv2+ wrong?

I thought as long as v2 is explicitly mentioned we're fine.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
