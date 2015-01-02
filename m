Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbbABIGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 03:06:21 -0500
Received: from mga14.intel.com ([192.55.52.115]:2174 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbbABIGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 03:06:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,683,1413270000"; 
   d="scan'208";a="655945238"
Message-ID: <54A65113.2080901@intel.com>
Date: Fri, 02 Jan 2015 10:04:35 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: perf: util: session:  Remove unused function
References: <1420134636-842-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1420134636-842-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/15 19:50, Rickard Strandqvist wrote:
> Remove the function perf_session__peek_event() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---

It was added in preparation for Intel PT and is still needed. Please do not
remove.

For example it is used here:

	http://marc.info/?l=linux-kernel&m=141839228619389

