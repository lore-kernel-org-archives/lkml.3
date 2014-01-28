Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaA1NEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 08:04:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaA1NEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 08:04:35 -0500
Date: Tue, 28 Jan 2014 14:04:08 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH 00/16] perf tools: Add libdw DWARF unwind support
Message-ID: <20140128130408.GF1229@krava.brq.redhat.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
 <20140117122431.GC1130@krava.brq.redhat.com>
 <CAFrcx1nadiFDq1hyha83Y9GEJmKvXDeW-+7mLA+zj3jE9H5iWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1nadiFDq1hyha83Y9GEJmKvXDeW-+7mLA+zj3jE9H5iWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 01:27:53PM +0100, Jean Pihet wrote:
> Hi Jiri,
> 
> Let me start on it next week. Is that OK?
> 
> Thx for the reminder, I had not entirely forgotten it though ;p
hi,
rebased patchset to latest acme's perf/core is in:
  https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/
  perf/core_libdw_unwind

aaand ping ;-)

thanks,
jirka
