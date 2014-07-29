Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaG2PRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:17:25 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:56763
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753431AbaG2PRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:17:24 -0400
Date: Tue, 29 Jul 2014 10:17:13 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sasha Levin <sasha.levin@oracle.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V8
In-Reply-To: <20140728145443.dce6fe72aed1bbdcf95b21f6@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1407291011230.21102@gentwo.org>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <53D31101.8000107@oracle.com> <alpine.DEB.2.11.1407281353450.15405@gentwo.org> <20140728145443.dce6fe72aed1bbdcf95b21f6@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Andrew Morton wrote:

> Also, Sasha's report showed this:
>
> [  490.464613] kernel BUG at mm/vmstat.c:1278!
>
> That's your VM_BUG_ON() in vmstat_update().  That ain't no false
> positive!

AFAICT this is because of the earlier BUG().


