Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3JNPXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:23:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52689 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab3JNPXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:23:50 -0400
Date: Mon, 14 Oct 2013 17:23:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fmc: BUG: scheduling while atomic: swapper/0/1/0x00000002
Message-ID: <20131014152339.GI4009@pd.tnic>
References: <20131014123406.GG4009@pd.tnic>
 <20131014151017.GA13363@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131014151017.GA13363@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 05:10:17PM +0200, Alessandro Rubini wrote:
> Hello.
> 
> > I'm getting the following with randconfig testing in kvm, config is
> > .attached.
> 
> I acknowledge this is a bug of mine, and your .config shows your are
> testing v3.11.
> 
> I posted the fix on Jul 16th 2013, and it is now in master as
> v3.11-rc2-11-g783c2fb.  However it is not an ancestor of v3.11, which
> still has the bug.  "git tag --contains 783c2fb" reports v3.12-rc1 as
> the first "official" kernel with the fix,

Right, I found that bug report from July but didn't find the fix to it.
Thanks for letting me know.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
