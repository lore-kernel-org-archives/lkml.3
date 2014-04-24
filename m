Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaDXNqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:46:53 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50311 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbaDXNqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:46:51 -0400
Subject: Re: [PATCH 04/11] perf hists: Add a couple of hists stat helper
 functions
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20140424131209.GF1110@krava.brq.redhat.com>
References: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
	 <1398327843-31845-5-git-send-email-namhyung@kernel.org>
	 <20140424094059.GA1110@krava.brq.redhat.com>
	 <1398344266.1681.5.camel@leonhard>
	 <20140424131209.GF1110@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Apr 2014 22:46:43 +0900
Message-ID: <1398347203.1681.22.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-24 (목), 15:12 +0200, Jiri Olsa:
> On Thu, Apr 24, 2014 at 09:57:46PM +0900, Namhyung Kim wrote:
> > 2014-04-24 (목), 11:40 +0200, Jiri Olsa:
> > > maybe I'm missing some case, but why is not 'nr_non_filtered_samples'
> > > reset/increased in hists__reset_filter_stats/hists__inc_filter_stats functions?
> > 
> > Because basically number of sample is counted at input stage, and these
> > functions are called at output stage.  But if a new filter is applied,
> > we need to re-count the numbers for the filter so it needs to be counted
> > separately.
> 
> ok.. I'll queue this for perf/core

Thank you so much!
Namhyung


