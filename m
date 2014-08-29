Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaH2H0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:26:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56988 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaH2H0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:26:08 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v4 3/3] perf/sdt : Documentation for SDT events
References: <20140827213745.13454.46266.stgit@hemant-fedora>
	<20140827215120.13454.30680.stgit@hemant-fedora>
Date: Fri, 29 Aug 2014 16:26:05 +0900
In-Reply-To: <20140827215120.13454.30680.stgit@hemant-fedora> (Hemant Kumar's
	message of "Thu, 28 Aug 2014 03:23:16 +0530")
Message-ID: <8738cfbvua.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014 03:23:16 +0530, Hemant Kumar wrote:
>  SYNOPSIS
>  --------
>  [verse]
> -'perf list' [hw|sw|cache|tracepoint|pmu|event_glob]
> +'perf list' [hw|sw|cache|tracepoint|pmu|sdt|event_glob]

What about adding it to a different line as the 'sdt' subcommand needs
an extra argument?

  [verse]
  'perf list' [hw|sw|cache|tracepoint|pmu|event_glob]
  'perf list' sdt <file>


Thanks,
Namhyung
