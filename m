Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaIAGBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:01:12 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49821 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaIAGBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:01:11 -0400
Message-ID: <54040BA0.2070900@hitachi.com>
Date: Mon, 01 Sep 2014 15:01:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: Re: [PATCH v4 3/3] perf/sdt : Documentation for SDT events
References: <20140827213745.13454.46266.stgit@hemant-fedora> <20140827215120.13454.30680.stgit@hemant-fedora> <8738cfbvua.fsf@sejong.aot.lge.com>
In-Reply-To: <8738cfbvua.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/29 16:26), Namhyung Kim wrote:
> On Thu, 28 Aug 2014 03:23:16 +0530, Hemant Kumar wrote:
>>  SYNOPSIS
>>  --------
>>  [verse]
>> -'perf list' [hw|sw|cache|tracepoint|pmu|event_glob]
>> +'perf list' [hw|sw|cache|tracepoint|pmu|sdt|event_glob]
> 
> What about adding it to a different line as the 'sdt' subcommand needs
> an extra argument?
> 
>   [verse]
>   'perf list' [hw|sw|cache|tracepoint|pmu|event_glob]
>   'perf list' sdt <file>

Agreed, at this point, "perf list sdt" requires a filename.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


