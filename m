Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaEEHHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:07:14 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:39520 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaEEHHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:07:12 -0400
MIME-Version: 1.0
X-Originating-IP: [178.145.152.36]
In-Reply-To: <20140502165105.GD20642@arm.com>
References: <CAFrcx1nfkDWTu9vF+a7UGjd1fzHpXS44pzqKLZS9ej7KJwqkOg@mail.gmail.com>
	<1398690730-5454-1-git-send-email-jean.pihet@linaro.org>
	<CAFrcx1kQO5i+kQwDizT1F4asbFNGiDSDWt0ubnpS92fU1PBiHw@mail.gmail.com>
	<20140502165105.GD20642@arm.com>
Date: Mon, 5 May 2014 09:07:11 +0200
Message-ID: <CAORVsuV5qYKLd21YSJhLy7Ovi5s4sXUEgbNot7LJspNnbdBpFw@mail.gmail.com>
Subject: Re: [PATCH 1/3] perf tests: Introduce perf_regs_load function on ARM64
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Steve Capper <steve.capper@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Patch Tracking <patches@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Fri, May 2, 2014 at 6:51 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, May 02, 2014 at 10:19:38AM +0100, Jean Pihet wrote:
>> Hi WIll, Mark,
>>
>> Ping on this series. Can you please check? Is the refreshed patch OK?
>
> Fine by me, as long as it's not reused outside of this test :)
Great! Is there some precaution to avoid a mis-reuse?

Other than that, which tree are the patches going to?

Cheers,
Jean

>
> Will
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
