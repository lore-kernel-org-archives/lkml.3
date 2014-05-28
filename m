Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaE1Gkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:40:39 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60127 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaE1Gkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:40:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with irqsoff tracers
Date: Wed, 28 May 2014 08:40:29 +0200
Message-ID: <6460837.vaSzv6fugQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140527193050.4606a014@gandalf.local.home>
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org> <53850FF3.8050107@codeaurora.org> <20140527193050.4606a014@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:m3vtrixSrWhbtFJcHcoIlv+wN94WbVCaNHBSQN/+mPm
 tjDx1+2LeGHNcBIuLNyGMYQUNeLkOvK/jFM/T5fbOPaoEoZ/Bh
 8c6ZPfwFgRHFTYOt3TMQErR15DmAvPmVCnblTqqF9I1eYDh8Ok
 awJT4Rl9dNNZiBPpBOQshdaLYmxf5pZrwlTeM9rD+pDWEjbl2N
 g9wRLORsBaPOavKPqPRIIbo+aJnXgSTOkGqiXKuzAS/t/TbqRm
 eJwwakqfNPmp4Nnhpu6L4rTRR+MLiSjoflQdaUzNxToAe3XT3c
 kYhzDgEEhciPie6lL6cDa1lEJ9hNw4CfY2ehgeX/p1jlFxDv8w
 zc96Q8e5paZcIOV/M+Rc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2014 19:30:50 Steven Rostedt wrote:
> On Tue, 27 May 2014 15:21:39 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
> 
> 
> > > Arnd brings up a good point. 
> > 
> > Hrm.. still not getting Arnd's mails.
> 
> Strange. What mail service do you have. Could they be blocking him?
> 

I think it's United Internet again getting blocked by some blacklist,
I has had bounces from arm.com addresses today.

	Arnd
