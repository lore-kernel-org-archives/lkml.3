Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3KAL4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab3KAL4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:56:39 -0400
Date: Fri, 1 Nov 2013 12:56:15 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 01/14] perf tools: Consolidate __hists__add_*entry()
Message-ID: <20131101115615.GA10041@krava.brq.redhat.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <1383202576-28141-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383202576-28141-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:56:03PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The __hists__add_{branch,mem}_entry() did almost same thing that
> __hists__add_entry() does.  Consolidate them into one.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
