Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936344Ab3DHO0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:26:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48699 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936039Ab3DHO0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:26:16 -0400
Date: Mon, 8 Apr 2013 16:26:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Joerg Roedel <joro@8bytes.org>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] buildtar: Add ARCH to the archive name
Message-ID: <20130408142600.GF4395@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Michal Marek <mmarek@suse.cz>, Joerg Roedel <joro@8bytes.org>,
	linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <1362557147-14393-1-git-send-email-bp@alien8.de>
 <20130307110659.GC22602@8bytes.org>
 <20130307110910.GA5834@pd.tnic>
 <5162CEC1.5070400@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5162CEC1.5070400@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 04:05:53PM +0200, Michal Marek wrote:
> On 7.3.2013 12:09, Borislav Petkov wrote:
> > On Thu, Mar 07, 2013 at 12:06:59PM +0100, Joerg Roedel wrote:
> >> Good idea, but I already hear people yelling about their scripts that
> >> break with this change :)
> > 
> > They better fix them then. :-)
> 
> OK, I applied the patch to kbuild.git#misc. Let's see how many people
> protest...

Yeah, leave it in there for 3.10 so that it sees a whole cycle of
testing in -next and what not, so that we can see who complains. :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
