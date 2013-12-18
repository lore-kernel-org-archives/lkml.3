Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3LRRjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:39:16 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:45333 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3LRRjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:39:15 -0500
Date: Wed, 18 Dec 2013 14:39:07 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/18] perf sort: Compare addresses if no symbol info
Message-ID: <20131218173907.GB4819@ghostprotocols.net>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
 <1387344086-12744-2-git-send-email-namhyung@kernel.org>
 <20131218153849.GF4146@krava.brq.redhat.com>
 <20131218173528.GA4819@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218173528.GA4819@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 18, 2013 at 02:35:28PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Dec 18, 2013 at 04:38:49PM +0100, Jiri Olsa escreveu:
> > > +static int64_t _sort__addr_cmp(u64 left_ip, u64 right_ip)
> > > +{
> > > +	return (int64_t)(right_ip - left_ip);
> > > +}
> > > +
> > 
> > what's the reason for the leading '_' in the name?
> 
> Yeah, I'm curious as well, the convention is to only use double _ in
> front of functions when it does a little less than a function of the
> same name without such prefix, like locking, etc.
> 
> - Arnaldo
>  
> > otherwise:
> > 
> > Acked-by: Jiri Olsa <jolsa@redhat.com>

Yeah, I'll apply it, it just keeps whatever convention that is there
already. I'll take a stab at fixing it all up after merging this
--whatever-the-cumulate-option-becomes new code :-)

- Arnaldo
