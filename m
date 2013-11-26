Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3KZKRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:17:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab3KZKR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:17:29 -0500
Date: Tue, 26 Nov 2013 11:16:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 2/3] perf record: Use perf_data_file__write for output
 file
Message-ID: <20131126101655.GC1267@krava.brq.redhat.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <1385130268-10664-3-git-send-email-jolsa@redhat.com>
 <20131125193137.GB27323@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125193137.GB27323@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 04:31:37PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 22, 2013 at 03:24:27PM +0100, Jiri Olsa escreveu:
> > Changing the file output code to use the newly
> > added perf_data_file__write interface.
> 
> So I like renaming write_output() to perf_record__write(), but then
> you're lumping together this change and the other, which is to make
> write_output, now renamed to perf_record__write() to use perf_data_file.
> 
> Can you please split it like that?
> 

ok, will do

thanks,
jirka
