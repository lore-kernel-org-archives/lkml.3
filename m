Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbbAZMpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:45:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48642 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbbAZMpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:45:39 -0500
Date: Mon, 26 Jan 2015 13:45:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 3/3] x86, crash: Allocate enough low-mem when
 crashkernel=high
Message-ID: <20150126124529.GB1656@pd.tnic>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-4-git-send-email-joro@8bytes.org>
 <20150123170243.GG22635@pd.tnic>
 <20150126121142.GG30345@8bytes.org>
 <20150126122017.GA1656@pd.tnic>
 <20150126124005.GC4653@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150126124005.GC4653@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 01:40:06PM +0100, Joerg Roedel wrote:
> Yes. Given that we have no data about what would work on most
> systems, we can only change the value to a number that fixes know
> problems and then act on possible regressions caused by the change (and
> that change is pretty easy to revert if needed).

... and I think we can safely concentrate on kdump-specific usage anyway
and de-prioritize the others. Like not adding in the radeon module to
initramfs and such. I don't think we want to show a funky graphic while
dumping the first kernel.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
