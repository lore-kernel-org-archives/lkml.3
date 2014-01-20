Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaATMay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:30:54 -0500
Received: from mail1.unitn.it ([193.205.206.20]:56832 "EHLO mail1.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbaATMaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:30:35 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2014 07:30:35 EST
Message-ID: <52DD15AA.8060201@unitn.it>
Date: Mon, 20 Jan 2014 13:25:14 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de
CC: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com>
In-Reply-To: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,

On 01/20/2014 11:40 AM, Juri Lelli wrote:
> From: Dario Faggioli <raistlin@linux.it>
>
> Add in Documentation/scheduler/ some hints about the design
> choices, the usage and the future possible developments of the
> sched_dl scheduling class and of the SCHED_DEADLINE policy.
[...]
> + References:
> +  1 - C. L. Liu and J. W. Layland. Scheduling algorithms for multiprogram-
> +      ming in a hard-real-time environment. Journal of the Association for
> +      Computing Machinery, 20(1), 1973.
> +  2 - L. Abeni , G. Buttazzo. Integrating Multimedia Applications in Hard
> +      Real-Time Systems. Proceedings of the 19th IEEE Real-time Systems
> +      Symposium, 1998. http://retis.sssup.it/~giorgio/paps/1998/rtss98-cbs.pdf
> +  3 - L. Abeni. Server Mechanisms for Multimedia Applications. ReTiS Lab
> +      Technical Report. http://xoomer.virgilio.it/lucabe72/pubs/tr-98-01.ps
I do not know how stable the "xoomer.virtgilio.it" URL is (and I lost the password
for this web site :).
I can host the technical report on unitn.it; I think it's more reliable. If you think
this is a good idea, I'll provide you with an updated URL (also, this is an old
document, written in "not so good" English... If there is interest, I can search for
the latex sources and update the document).



				Luca
