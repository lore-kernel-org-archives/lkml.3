Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbaGXSCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:02:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:9935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbaGXSCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:02:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,725,1400050800"; 
   d="scan'208";a="578437355"
Message-ID: <53D149F2.4090001@intel.com>
Date: Thu, 24 Jul 2014 21:01:22 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org> <53CCB6AE.6020505@intel.com> <20140721080219.GA4183@krava.redhat.com> <53CCD3A7.5070002@intel.com> <20140721095415.GB8865@krava.redhat.com> <87d2cy3c7m.fsf@tassilo.jf.intel.com> <53CD5AB5.3000307@intel.com> <53CD5DC6.3030605@gmail.com> <20140724141958.GB7831@kernel.org>
In-Reply-To: <20140724141958.GB7831@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/2014 5:19 p.m., Arnaldo Carvalho de Melo wrote:
>
> David, can I have your Acked-by for just those two while the rest is debated?
>
> Adrian, can I have yours as well?

Yes you have my Ack for patches 1 and 17
