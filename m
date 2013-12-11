Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3LKWWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:22:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:36926 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3LKWWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:22:43 -0500
Date: Wed, 11 Dec 2013 23:22:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Len Brown <lenb@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Mike Galbraith <bitbucket@online.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
In-Reply-To: <CAJvTdKm5sdT8R-DNGNWyebTKYDqP49dQMds9++TkF=aF8O=V7Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1312112320320.28330@ionos.tec.linutronix.de>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com> <1386478624.4748.19.camel@marge.simpson.net> <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com> <1386559014.4875.16.camel@marge.simpson.net>
 <1386652637.5374.72.camel@marge.simpson.net> <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de> <1386732093.5964.6.camel@marge.simpson.net> <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
 <20131211113839.GF21683@pd.tnic> <20131211115239.GA21999@twins.programming.kicks-ass.net> <CAJvTdKm5sdT8R-DNGNWyebTKYDqP49dQMds9++TkF=aF8O=V7Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Len Brown wrote:

> For the record...
> 
> intel_idle doesn't check that bit because it doesn't run on model 29 --
> the Xeon 7400 was the "Dunnington" 4-socket generation based on Core2.

Right, we wondered about the restricted model check
already. Interesting that this is a 4 socket issue as well.

> Until now, i was not aware that this issue might apply to models other
> than that one.
> 
> Checking w/ the HW guys...

I hope they are not equally surprised :)

Thanks,

	tglx
