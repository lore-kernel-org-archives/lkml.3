Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaKCHwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:52:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:30983 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbaKCHwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:52:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,305,1413270000"; 
   d="scan'208";a="615866428"
Message-ID: <545733E7.6010105@intel.com>
Date: Mon, 03 Nov 2014 09:51:03 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/8] perf tools: Get rid of unused dsos__hit_all()
References: <1414999678-31377-1-git-send-email-namhyung@kernel.org> <1414999678-31377-4-git-send-email-namhyung@kernel.org> <5457305B.9080404@intel.com> <CAM9d7cjfBXrd-8JxDAfG7OM7X_XxkojFnrxpbGVVUW_xwnwkbA@mail.gmail.com>
In-Reply-To: <CAM9d7cjfBXrd-8JxDAfG7OM7X_XxkojFnrxpbGVVUW_xwnwkbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/14 09:39, Namhyung Kim wrote:
> Hi Adrian,
> 
> On Mon, Nov 3, 2014 at 4:35 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
>> On 03/11/14 09:27, Namhyung Kim wrote:
>>> The dsos__hit_all() and its friends are not used anywhere.  Let's get
>>> rid of them.
>>
>> They were added for Intel PT preparation.  Intel PT is still on its way,
>> so they are still needed.  Note the commit was:
>>
>> commit 1f625b0b3dd641b74ba21640a1fea19a3dd893a2
>> Author: Adrian Hunter <adrian.hunter@intel.com>
>> Date:   Tue Jul 22 16:17:23 2014 +0300
>>
>>     perf tools: Add dsos__hit_all()
>>
>>     Add ability to mark all dsos as hit.
>>
>>     This is needed in the case of Instruction Tracing.  It takes so long to
>>     decode an Instruction Trace that it is not worth doing just to determine
>>     which dsos are hit.  A later patch takes this into use.
> 
> Oops, didn't notice.  Sorry for not checking the commit log.  So how
> about moving it into util/build-id.c then?

OK by me.

