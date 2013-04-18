Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030361Ab3DRKYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:24:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51954 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967505Ab3DRKYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:24:45 -0400
Date: Thu, 18 Apr 2013 12:24:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Will Huck <will.huckk@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>,
        Behan Webster <behanw@converseincode.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab: Remove unnecessary __builtin_constant_p()
Message-ID: <20130418102438.GA21722@pd.tnic>
References: <1366225776.8817.28.camel@pippen.local.home>
 <516F3B30.30307@gmail.com>
 <alpine.DEB.2.02.1304171731410.26200@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304171731410.26200@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 05:32:03PM -0700, David Rientjes wrote:
> On Thu, 18 Apr 2013, Will Huck wrote:
> 
> > In normal case, builtin_constant_p() is used for what?
> > 
> http://gcc.gnu.org/onlinedocs/

Yeah, there's also this very educating site for situations like this
one:

http://lmgtfy.com

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
