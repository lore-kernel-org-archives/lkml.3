Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaAUJuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:50:32 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35773 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbaAUJua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:50:30 -0500
MIME-Version: 1.0
In-Reply-To: <CALZhoSTzGH+mAB-Om=3dQTgQJriDmH+is_DEAzWNN7rRpzNFuQ@mail.gmail.com>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<CALZhoSRvhqJXU=z=h30SS6USjHFe3yKLsJN9WzQr6ch0sxoN-g@mail.gmail.com>
	<CAKohpokbb3ko3sW4kuDKZSoY1qJ6apVVR3-jpv=7m5ZX__YP8Q@mail.gmail.com>
	<20140120154058.GA9436@localhost.localdomain>
	<CALZhoSTzGH+mAB-Om=3dQTgQJriDmH+is_DEAzWNN7rRpzNFuQ@mail.gmail.com>
Date: Tue, 21 Jan 2014 15:20:29 +0530
Message-ID: <CAKohponrix+rueH025A1z6r0iaqTpbXHEgdXMKUCm6fvKWAbvQ@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2014 07:37, Lei Wen <adrian.wenl@gmail.com> wrote:
> What is more, I also did  similiar test, and find when I set two such
> cpuset group,
> like core 0-2 to cpuset1, core 3 to cpuset2, while hotunplug the core3
> afterwise.
> I find the cpuset's cpus member becomes NULL even I hotplug the core3
> back again.
> So is it a bug?

I confirm the same :)
