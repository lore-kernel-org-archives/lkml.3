Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3LKNk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:40:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37367 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3LKNkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:40:55 -0500
Date: Wed, 11 Dec 2013 14:40:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <bitbucket@online.de>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
Message-ID: <20131211134048.GH21683@pd.tnic>
References: <1386559014.4875.16.camel@marge.simpson.net>
 <1386652637.5374.72.camel@marge.simpson.net>
 <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de>
 <1386732093.5964.6.camel@marge.simpson.net>
 <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
 <20131211113839.GF21683@pd.tnic>
 <20131211115239.GA21999@twins.programming.kicks-ass.net>
 <1386764955.12005.60.camel@marge.simpson.net>
 <20131211124352.GB21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131211124352.GB21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 01:43:52PM +0100, Peter Zijlstra wrote:
> Something like the below.. someone needs to double check and possibly
> add SNB/IVB EX parts if they're already available.

Right, our friends at Intel would need to tell us which families/models
does AAI65 span... if, this is actually the case.

But now that Mike's box is fixed too, it very much looks like it.

Oh, and AAIxx errata are Intel Xeon Processor 7400 Series ones, we would
also need to know whether other incarnations are affected too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
