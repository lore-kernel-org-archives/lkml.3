Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbaDVKhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:37:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39324 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718AbaDVKhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:37:45 -0400
Date: Tue, 22 Apr 2014 11:37:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
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
Message-ID: <20140422103744.GG7484@arm.com>
References: <1395222155-22205-1-git-send-email-jean.pihet@linaro.org>
 <1395222155-22205-2-git-send-email-jean.pihet@linaro.org>
 <20140321151126.GR23372@e106331-lin.cambridge.arm.com>
 <CAFrcx1=TSsaDK0xgtJSQUtvUnwicrXNU-nYAcMOi4B=nTU_Qwg@mail.gmail.com>
 <CAFrcx1m_iH1ivWdTi7tbMXxEq1KYqHOAQS3hh3hnJh2ZgEDP3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1m_iH1ivWdTi7tbMXxEq1KYqHOAQS3hh3hnJh2ZgEDP3Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 09:13:33AM +0100, Jean Pihet wrote:
> Hi Mark, Will,

Hi Jean,

> Ping on this series. Can you please check? I

Do you have a pointer to the latest version of your code please? The email
backlog I have seems to end with MarkR saying he would take a look.

Will
