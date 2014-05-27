Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaE0UHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:07:51 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:56828 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbaE0UHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:07:49 -0400
Date: Tue, 27 May 2014 15:07:45 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V5
In-Reply-To: <alpine.DEB.2.02.1405150111480.6261@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1405271507090.15990@gentwo.org>
References: <alpine.DEB.2.10.1405121317270.29911@gentwo.org> <alpine.DEB.2.02.1405131651120.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405141105370.16512@gentwo.org> <alpine.DEB.2.02.1405150111480.6261@ionos.tec.linutronix.de>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Thomas Gleixner wrote:

> Acked-by me for the general approach.
>
> I don't want to give any unqualified opinion on the mm/vmstat parts of
> this patch.

Thanks. Any other comments? Could we get this into -next?

