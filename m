Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3GJGeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:34:15 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:61381 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3GJGeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:34:13 -0400
MIME-Version: 1.0
In-Reply-To: <51DCF982.4070707@linux.vnet.ibm.com>
References: <1443144.WnBWEpaopK@amdc1032>
	<51DB724F.9050708@linux.vnet.ibm.com>
	<1754044.EVIH1UZj6p@amdc1032>
	<51DC0B0D.9070201@linux.vnet.ibm.com>
	<51DCDF1C.1000208@linux.vnet.ibm.com>
	<CAKohpokbo+X5bEYweBuSqr5bkdRsb-XHT7SrMWybwAvkfDsGBQ@mail.gmail.com>
	<51DCF982.4070707@linux.vnet.ibm.com>
Date: Wed, 10 Jul 2013 12:04:12 +0530
Message-ID: <CAKohpomDednjDAtGR7Ccj3-mnRHpotUnFcDKjw=u9Y-Svq7swA@mail.gmail.com>
Subject: Re: [v3.10 regression] deadlock on cpu hotplug
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2013 11:34, Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
> Thanks for the confirm :) seems like the root cause is very likely
> related with the problem Srivatsa discovered.
>
> I think the fix in his mail worth a try, but I need more investigations
> to confirm that's the right way...

Its not a fix really, but with that we can atleast confirm that we are on
the right path and the problem is exactly what he described.
