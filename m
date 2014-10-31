Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbaJaUgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:36:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56428 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaJaUf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:35:58 -0400
Date: Fri, 31 Oct 2014 21:35:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Juergen Gross <jgross@suse.com>, hpa@zytor.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, stefan.bader@canonical.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH 01/17] x86: Make page cache mode a real type
Message-ID: <20141031203554.GA15363@pd.tnic>
References: <1414764033-30011-1-git-send-email-jgross@suse.com>
 <1414764033-30011-2-git-send-email-jgross@suse.com>
 <20141031194207.GA15367@pd.tnic>
 <20141031202322.GB15935@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141031202322.GB15935@laptop.dumpdata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 04:23:22PM -0400, Konrad Rzeszutek Wilk wrote:
> > > Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> > > Signed-off-by: Juergen Gross <jgross@suse.com>
> > 
> > Just a clarification question: how is one to understand this attribution
> > here? Is Stefan the original author, was he a reviewer, or? Because this
> > SOB chain is misleading...
> 
> He was the first then Juergen took over. Should the SOB order be inversed?

Well, I'd say:

Originally-by: Stefan...

or

Based-on-patch-by: Stefan...

or something like that. For more inspiration, one could do something
like that:

$ git log | grep -Eio "original.*by:" | sort | uniq
original bug can be reproduced and the bug fix can be verified by:
Original-by:
original by or fixed by:
Original-code-by:
Original-coded-by:
original driver was written by:
Original i2c code by:
Original-Idea-and-Signed-off-by:
Original idea by:
Original-idea-by:
originally by:
Originally by:
Originally-by:
originally made by:
Originally reported by:
Originally-Reported-by:
originally submitted by:
originally written by:
Original partial fix Signed-off-by:
original patch authored by:
original patch by:
original-patch-by:
Original patch by:
Original-patch-by:
Original-Patch-By:
Original patches by:
original-screenplay-by:
Original-Signed-off-by:
Original-version-by:
original work completed by:

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
