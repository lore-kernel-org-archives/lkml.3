Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab3LLF7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:59:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50575 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3LLF7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:59:17 -0500
Message-ID: <1386827824.6056.36.camel@marge.simpson.net>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Mike Galbraith <bitbucket@online.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Date: Thu, 12 Dec 2013 06:57:04 +0100
In-Reply-To: <6e4b858b-fcad-4231-8351-d2f473bf6ba6@email.android.com>
References: <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
	 <20131211113839.GF21683@pd.tnic>
	 <20131211115239.GA21999@twins.programming.kicks-ass.net>
	 <1386764955.12005.60.camel@marge.simpson.net>
	 <20131211124352.GB21999@twins.programming.kicks-ass.net>
	 <20131211134048.GH21683@pd.tnic> <20131211145655.GB4510@gmail.com>
	 <20131211164318.GA2480@laptop.programming.kicks-ass.net>
	 <20131211175036.GC12431@gmail.com> <52A8F073.9040500@zytor.com>
	 <20131211231425.GD8863@pd.tnic> <52A908DB.60902@zytor.com>
	 <1386822357.6056.12.camel@marge.simpson.net> <52A94065.1050103@zytor.com>
	 <1386826641.6056.31.camel@marge.simpson.net>
	 <6e4b858b-fcad-4231-8351-d2f473bf6ba6@email.android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:utd5nPUyC2MKx/lkGE3zOcwXsVlbylEx1G7giWFxXzM
 aLZTeBdcnlOfisOc35JMwpnExupmPBfqvdOnpBD7VfbgwQP0/Y
 x/DPYkBy5PZjWqdHthbL91iZLwpSIuim8yc5n259az3AnNYmHR
 3xZ3jqTLR26GyE14s9GR8+eMSCf3TFVl8xGmwfgEUJ3LRl9dCj
 teVD9H5lBV43o9ZcPu6OhpQ6oF0eQbNIqhp44OBK3iSqQVWIQH
 /uo8mazyS4hj/j6IH4SJe4sy6XXo1cG0U/8ZBYFb546sPpqoWC
 dm3NTH12JIF/uMiDRU7BBTSirw2CifUiItSRdb3QUVSuAKG3If
 oWTRPKR5xzek6gehL+d19WC3mDyVpBSTpAeFOfx04L9q2skW2R
 VU8MZAKAE7QkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 21:45 -0800, H. Peter Anvin wrote: 
> As in it hangs at that point?

Nope, it's still going.

[1567.578340] pcc-cpufreq: (v1.10.00) driver loaded with frequency limits: 1064 MHz, 2266 MHz

Funny, continents move faster :)  Maybe missing a write or two.

-Mike

