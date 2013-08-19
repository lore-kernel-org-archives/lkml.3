Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3HSJSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:18:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50248 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab3HSJSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:18:51 -0400
Date: Mon, 19 Aug 2013 11:18:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH tip/core/rcu 01/11] rcu: Expedite grace periods during
 suspend/resume
Message-ID: <20130819091848.GA4165@pd.tnic>
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818031717.GL28923@leaf>
 <20130818093444.GA26728@pd.tnic>
 <20130819002910.GR29406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130819002910.GR29406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 05:29:10PM -0700, Paul E. McKenney wrote:
> I would guess that once we have a few more subsystems that want
> RCU to temporarily expedite its grace periods, we will have enough
> information and experience to do something a bit more general. In the
> meantime, I am opting for something simple. ;-)

Aah, the empirical approach! Very wise, master Jedi :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
