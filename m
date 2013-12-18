Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3LROjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:39:18 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56903 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3LROjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:39:16 -0500
Subject: Re: [RFC/PATCHSET 00/18] perf report: Add support to accumulate
 hist periods (v3)
From: Namhyung Kim <namhyung@kernel.org>
To: Arun Sharma <asharma@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
In-Reply-To: <52B17B14.5030101@fb.com>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
	 <20131218094622.GA19240@gmail.com>  <52B17B14.5030101@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Dec 2013 23:39:09 +0900
Message-ID: <1387377549.1717.14.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,

2013-12-18 (수), 16:08 +0530, Arun Sharma:
> On 12/18/13 3:16 PM, Ingo Molnar wrote:
> 
> > My main complaint that any variation of 'cumulative' or 'cumulate' is
> > a tongue-twister to users. I certainly won't be able to remember it
> > and will have to call up the manpage every time I use it - which will
> > be very annoying. I'd probably not use the feature much.
> 
> I can remember it, mainly because it's such an unusual word :)
> Agree that we could use something simpler/easier to remember.
> 
> My other user space projects have been keeping me busy. But still very 
> interested in this feature. Will test this patch series over the holidays.

Thanks in advance for your test and feedback! :)
Namhyung


