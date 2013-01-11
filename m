Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3AKVBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:01:20 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:53837 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab3AKVBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:01:19 -0500
Date: Fri, 11 Jan 2013 01:57:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf_event: missing field in PERF_RECORD_SAMPLE
 documentation (resend)
Message-ID: <20130111045744.GC3054@ghostprotocols.net>
References: <alpine.DEB.2.02.1211061529590.23901@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1301081439300.24507@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1301081439300.24507@vincent-weaver-1.um.maine.edu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 08, 2013 at 02:44:25PM -0500, Vince Weaver escreveu:
> I sent this in November with no response, but the patch still 
> applies.
> 
> While trying to write a perf_event/mmap test for my perf_event 
> test-suite I came across a missing field description in the 
> PERF_RECORD_SAMPLE documentation in perf_event.h

Thanks, applied to my perf/core branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux

- Arnaldo
