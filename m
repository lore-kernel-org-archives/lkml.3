Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3EXNpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:45:23 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:32793 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3EXNpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:45:21 -0400
Date: Thu, 23 May 2013 11:56:47 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 03/14] perf tools: Add struct perf_hpp_fmt into hpp
 callbacks
Message-ID: <20130523095647.GB3064@ghostprotocols.net>
References: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
 <1355404152-16523-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355404152-16523-4-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 13, 2012 at 02:09:01PM +0100, Jiri Olsa escreveu:
> Adding 'struct perf_hpp_fmt' into hpp callbacks, so commands
> can access their private data.

>  tools/perf/ui/gtk/browser.c    |  10 +--

Doesn't apply here, can you please take a look?

- Arnaldo
