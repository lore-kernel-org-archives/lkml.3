Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaEFIvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:51:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52297 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934344AbaEFIvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:51:49 -0400
Date: Tue, 6 May 2014 09:51:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@newoldbits.com>
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
Subject: Re: [PATCH 1/3] perf tests: Introduce perf_regs_load function on
 ARM64
Message-ID: <20140506085144.GA26592@arm.com>
References: <CAFrcx1nfkDWTu9vF+a7UGjd1fzHpXS44pzqKLZS9ej7KJwqkOg@mail.gmail.com>
 <1398690730-5454-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1kQO5i+kQwDizT1F4asbFNGiDSDWt0ubnpS92fU1PBiHw@mail.gmail.com>
 <20140502165105.GD20642@arm.com>
 <CAORVsuV5qYKLd21YSJhLy7Ovi5s4sXUEgbNot7LJspNnbdBpFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAORVsuV5qYKLd21YSJhLy7Ovi5s4sXUEgbNot7LJspNnbdBpFw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 08:07:11AM +0100, Jean Pihet wrote:
> Hi Will,
> 
> On Fri, May 2, 2014 at 6:51 PM, Will Deacon <will.deacon@arm.com> wrote:
> > On Fri, May 02, 2014 at 10:19:38AM +0100, Jean Pihet wrote:
> >> Hi WIll, Mark,
> >>
> >> Ping on this series. Can you please check? Is the refreshed patch OK?
> >
> > Fine by me, as long as it's not reused outside of this test :)
> Great! Is there some precaution to avoid a mis-reuse?

Hopefully your comment will be enough.

> Other than that, which tree are the patches going to?

They're all under perf/tools/, so they should go via that tree.

Will
