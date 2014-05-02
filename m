Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaEBQvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:51:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45955 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbaEBQvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:51:08 -0400
Date: Fri, 2 May 2014 17:51:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Patch Tracking <patches@linaro.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steve Capper <steve.capper@linaro.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 1/3] perf tests: Introduce perf_regs_load function on
 ARM64
Message-ID: <20140502165105.GD20642@arm.com>
References: <CAFrcx1nfkDWTu9vF+a7UGjd1fzHpXS44pzqKLZS9ej7KJwqkOg@mail.gmail.com>
 <1398690730-5454-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1kQO5i+kQwDizT1F4asbFNGiDSDWt0ubnpS92fU1PBiHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1kQO5i+kQwDizT1F4asbFNGiDSDWt0ubnpS92fU1PBiHw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 10:19:38AM +0100, Jean Pihet wrote:
> Hi WIll, Mark,
> 
> Ping on this series. Can you please check? Is the refreshed patch OK?

Fine by me, as long as it's not reused outside of this test :)

Will
