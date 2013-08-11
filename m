Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3HKIh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 04:37:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53449 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3HKIhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 04:37:23 -0400
Date: Sun, 11 Aug 2013 10:37:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Hard lockups using 3.10.0
Message-ID: <20130811083718.GA9461@pd.tnic>
References: <8484013.LsABBJRIOx@devpool02>
 <20130711100721.GA28131@pd.tnic>
 <20130711105207.GE25631@dyad.programming.kicks-ass.net>
 <24155824.fdsQYPMaDK@donald.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <24155824.fdsQYPMaDK@donald.sf-tec.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 08:09:19AM +0200, Rolf Eike Beer wrote:
> Meanwhile I found that there was a hardware defect on this machine.
> So if it does not happen again I will assume that this was caused by
> this.

What hardware defect exactly? DIMMs failing...? Probably, since it looks
like the spinlock gets corrupted and the assertion fires... In any case,
it would be interesting to know for future reference.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
