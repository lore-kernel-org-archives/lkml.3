Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaHGBvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:51:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40619 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaHGBvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:51:11 -0400
Message-ID: <53E2DB4C.3060109@oracle.com>
Date: Wed, 06 Aug 2014 21:50:04 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: akpm@linux-foundation.org, Gilad Ben-Yossef <gilad@benyossef.com>,
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
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <53D31101.8000107@oracle.com> <53DFFD28.2030502@oracle.com> <alpine.DEB.2.11.1408050950390.16902@gentwo.org> <53E159F6.7080603@oracle.com> <alpine.DEB.2.11.1408060908580.4346@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1408060908580.4346@gentwo.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 10:12 AM, Christoph Lameter wrote:
> On Tue, 5 Aug 2014, Sasha Levin wrote:
> 
>> > I can easily trigger it by cranking up the cpu hotplug code. Just try to
>> > frequently offline and online cpus, it should reproduce quickly.
> Thats what I thought.
> 
> The test was done with this fix applied right?

Nope, I never saw the patch before. Applied it and the problem goes away. Thanks!


Thanks,
Sasha
