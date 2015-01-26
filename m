Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbbAZWkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 17:40:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36851 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbbAZWkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 17:40:05 -0500
Date: Mon, 26 Jan 2015 23:39:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/2] add support for new persistent memory instructions
Message-ID: <20150126223954.GJ1656@pd.tnic>
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
 <54C2D34D.7010709@intel.com>
 <20150124111430.GA10084@pd.tnic>
 <1422302369.13382.3.camel@theros.lm.intel.com>
 <20150126213457.GI1656@pd.tnic>
 <1422309007.14456.1.camel@theros.lm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422309007.14456.1.camel@theros.lm.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 02:50:07PM -0700, Ross Zwisler wrote:
> We can use MFENCE, but I don't think we need to. With SFENCE we will
> be ordered with respect to stores, and the flushes and pcommit will be
> ordered with respect to one another. I think you can sprinkle in loads
> anywhere you want in that flow and everything will work.


Ok, maybe we should hold down that sequence and this somewhere as a
this-is-how-you-should-do-pcommit-properly explanation or so... or do
you have an actual patch adding write_and_commit_buffer()?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
