Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbaDVNYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:24:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45830 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbaDVNYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:24:35 -0400
Date: Tue, 22 Apr 2014 14:24:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <Will.Deacon@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Steve Capper <steve.capper@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 1/3] perf tests: Introduce perf_regs_load function on
 ARM64
Message-ID: <20140422132431.GB9625@e106331-lin.cambridge.arm.com>
References: <1395222155-22205-1-git-send-email-jean.pihet@linaro.org>
 <1395222155-22205-2-git-send-email-jean.pihet@linaro.org>
 <20140321151126.GR23372@e106331-lin.cambridge.arm.com>
 <CAFrcx1=TSsaDK0xgtJSQUtvUnwicrXNU-nYAcMOi4B=nTU_Qwg@mail.gmail.com>
 <CAFrcx1m_iH1ivWdTi7tbMXxEq1KYqHOAQS3hh3hnJh2ZgEDP3Q@mail.gmail.com>
 <20140422103744.GG7484@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422103744.GG7484@arm.com>
Thread-Topic: [PATCH 1/3] perf tests: Introduce perf_regs_load function on
 ARM64
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:37:44AM +0100, Will Deacon wrote:
> On Tue, Apr 22, 2014 at 09:13:33AM +0100, Jean Pihet wrote:
> > Hi Mark, Will,
> 
> Hi Jean,
> 
> > Ping on this series. Can you please check? I
> 
> Do you have a pointer to the latest version of your code please? The email
> backlog I have seems to end with MarkR saying he would take a look.

The last posting I saw was [1-6]. The lack of reply is my fault, as I
lost track of the thread.

Cheers,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/241470.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/241467.html
[3] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/242396.html
[4] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/242998.html
[5] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/241466.html
[6] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/241468.html
