Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaLCUjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:39:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:55507 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLCUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:39:21 -0500
Date: Wed, 3 Dec 2014 21:39:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CANcMJZA1NXUMLEveA2k5njFnWc1pCSwSeAOQH7VQCOR-QtiR8g@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412032137210.16275@nanos>
References: <547bbe36.48548c0a.105c.779c@mx.google.com> <20141201191431.GA17385@linux.vnet.ibm.com> <547ccf74.a5198c0a.25de.26d9@mx.google.com> <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com> <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net> <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com> <1417540493.21136.3@mail.thefacebook.com> <20141203184111.GA32005@redhat.com> <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141203190045.GB32005@redhat.com> <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com> <CANcMJZA1NXUMLEveA2k5njFnWc1pCSwSeAOQH7VQCOR-QtiR8g@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, John Stultz wrote:
> I'll look around for some other suspects though. The nohz ntp
> improvments might be high on my list there, since it was a 3.17 item.
> Will dig.

Neither the clocksource watchdog nor the timestamp of the kernel
watchdog are affected by NTP adjustments.

Thanks,

	tglx
