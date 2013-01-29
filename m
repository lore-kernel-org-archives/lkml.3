Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3A2Q0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:26:34 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:51860 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3A2Q02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:26:28 -0500
Date: Tue, 29 Jan 2013 13:26:20 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf evsel:  Fix memory leaks on evsel->counts
Message-ID: <20130129162620.GA4512@ghostprotocols.net>
References: <1359078284-32080-1-git-send-email-namhyung@kernel.org>
 <20130125024558.GF1954@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125024558.GF1954@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 24, 2013 at 11:45:58PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Jan 25, 2013 at 10:44:44AM +0900, Namhyung Kim escreveu:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > The ->counts field was never freed in the current code.  Add
> > perf_evsel__free_counts() function to free it properly.
> 
> I still haven't applied Stephane's patches, that his one depends on,
> will do it tomorrow.

Done, applied, thanks!

- Arnaldo
