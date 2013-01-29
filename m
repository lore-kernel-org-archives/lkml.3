Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab3A2BQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:16:15 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53414 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3A2BQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:16:13 -0500
Message-ID: <5107225A.5040702@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 12:14:02 +1100
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Bob Liu <lliubbo@gmail.com>, tglx@linutronix.de, peterz@infradead.org,
        oleg@redhat.com, paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        mingo@kernel.org, akpm@linux-foundation.org, namhyung@kernel.org,
        rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 31/45] blackfin/smp: Use get/put_online_cpus_atomic()
 to prevent CPU offline
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <20130122074123.13822.39102.stgit@srivatsabhat.in.ibm.com> <CAA_GA1fSLNKSDTGSzHoA+j-mur85BvoSRkARq+DMfORuwrrX4Q@mail.gmail.com> <CAOS58YN_r-ahRvPekOo_84bM7z3YcFw1EA7DcTf0NVyEhv7ssA@mail.gmail.com>
In-Reply-To: <CAOS58YN_r-ahRvPekOo_84bM7z3YcFw1EA7DcTf0NVyEhv7ssA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012901-5816-0000-0000-00000674CDAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 06:06 AM, Tejun Heo wrote:
> Hello, Bob.
> 
> On Mon, Jan 28, 2013 at 1:09 AM, Bob Liu <lliubbo@gmail.com> wrote:
>> Thanks, will be applied to my blackfin arch tree.
> 
> I think we still have some work ahead of us to have this patchset
> ready for inclusion and even then it probably would be best to route
> these patches together, so probably not a very good idea to apply this
> to blackfin right now.
> 

Thanks Tejun for pointing that out! I'll address the review comments
soon and respin the patchset.
 
Regards,
Srivatsa S. Bhat

