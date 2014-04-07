Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaDGFRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:17:10 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34721 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaDGFRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <1396847090.5218.9.camel@marge.simpson.net>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
	<1396773020.11763.17.camel@marge.simpson.net>
	<CAKohpomW3jpQEqFxD3m_br8GchJyq9-KSxW2x7JLCRqDgf4SAg@mail.gmail.com>
	<1396847090.5218.9.camel@marge.simpson.net>
Date: Mon, 7 Apr 2014 10:47:05 +0530
Message-ID: <CAKohponiqqd_WZ=i3MS_Ls7=O=C+PnuNat77pME7M8z3nuJnAw@mail.gmail.com>
Subject: Re: [PATCH V2 0/8] cpusets: Isolate CPUs via sysfs using cpusets
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 April 2014 10:34, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> Yes, both on and off is kinda hard to do per cpu :)

Correct.. would get it fixed in V3..
