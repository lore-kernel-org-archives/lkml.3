Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaAJKGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:06:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39705 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbaAJKGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:06:09 -0500
Date: Fri, 10 Jan 2014 11:06:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, halfdog <me@halfdog.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Sanitize CPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
Message-ID: <20140110100604.GA12077@pd.tnic>
References: <20131231192106.GA22535@phenom.dumpdata.com>
 <52C347F0.8070902@zytor.com>
 <52CD022E.9040107@halfdog.net>
 <52CD8E10.3010204@zytor.com>
 <20140108193655.GD5098@pd.tnic>
 <52CDC316.4050503@halfdog.net>
 <52CDD3AE.4030301@zytor.com>
 <20140109225815.GI11594@pd.tnic>
 <CA+55aFxQnY_PCG_n4=0w-VG=YLXL-yr7oMxyy0WU2gCBAf3ydg@mail.gmail.com>
 <52CF573F.8030300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52CF573F.8030300@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 06:13:19PM -0800, H. Peter Anvin wrote:
> OK, that sounds very reasonable. Boris, halfdog, does something like
> this resolve your problem?

Yeah, if in doubt, Linus to the rescue! :)

Tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
