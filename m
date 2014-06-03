Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaFCJYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:24:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:17528 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbaFCJYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:24:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,964,1392192000"; 
   d="scan'208";a="521916499"
Message-ID: <538D93FB.6070309@intel.com>
Date: Tue, 03 Jun 2014 12:23:07 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Yann Droneaud <ydroneaud@opteya.com>, Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCHv5] perf tools: enable close-on-exec flag on perf file
 descriptor
References: <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>	 <20140106112436.GF31570@twins.programming.kicks-ass.net>	 <20140106144347.GA13500@ghostprotocols.net>	 <20140106142220.GB1183@krava.brq.redhat.com>	 <1389463628-24869-1-git-send-email-ydroneaud@opteya.com>	 <1389607770-4485-1-git-send-email-ydroneaud@opteya.com>	 <20140115185026.GA14248@ghostprotocols.net>	 <1390771203-28415-1-git-send-email-ydroneaud@opteya.com>	 <1394527147-7010-1-git-send-email-ydroneaud@opteya.com>	 <1401706594-4995-1-git-send-email-ydroneaud@opteya.com>	 <20140602192320.GD7861@krava.brq.redhat.com> <1401785835.32444.18.camel@localhost.localdomain>
In-Reply-To: <1401785835.32444.18.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 11:57 AM, Yann Droneaud wrote:
> Nice catch. This function was introduced by commit 
> c09ec622629eeb4b7877646a42852e7156363425 ('perf evlist: Add 
> can_select_event() method') by Adrian Hunter <adrian.hunter@intel.com>
> and it seems it was never used by perf tools.

It is part of preparation for Intel PT.

