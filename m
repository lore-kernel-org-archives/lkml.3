Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3LHJwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:52:47 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:15285
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755239Ab3LHJwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:52:46 -0500
X-IronPort-AV: E=Sophos;i="4.93,850,1378850400"; 
   d="scan'208";a="39881504"
Date: Sun, 8 Dec 2013 10:52:41 +0100
From: Martin Quinson <martin.quinson@loria.fr>
To: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Cc: Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: Re: quilt 0.60 does not include CCed email without name
Message-ID: <20131208095241.GK28085@alphonse.loria.fr>
References: <20131203233232.928771708@linux.com>
 <20131203233250.717784556@linux.com>
 <1386115809.2166.126.camel@dabdike.int.hansenpartnership.com>
 <alpine.DEB.2.02.1312051244540.26098@gentwo.org>
 <00000142c48e1f2a-fd398f0b-8726-4cec-a939-2c3a823bff39-000000@email.amazonses.com>
 <20131206081816.GQ9578@alphonse.loria.fr>
 <1587122162.1690.1386494371840.JavaMail.zimbra@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587122162.1690.1386494371840.JavaMail.zimbra@linbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 10:19:31AM +0100, Andreas Gruenbacher wrote:
> Martin,
> 
> > [...] bug seems to be caused by:
> > http://git.savannah.gnu.org/cgit/quilt.git/commit/?id=02f15444278eb3a854acae0192124153e0c6d9d4
> > 
> > I think that the last lines should be changed as follows (and same for
> > the one before):
> > - -e 's/^\('"$*"'\):\(.*<.*@.*>\)/Recipient-Cc:\2/Ip' \
> > + -e 's/^\('"$*"'\):\(.*@.*\)/Recipient-Cc:\2/Ip' \
> 
> or something similar like .\+@.\+ for the email address part, yes. 

Done. This will be part of quilt 0.61.

Thanks, Mt.

