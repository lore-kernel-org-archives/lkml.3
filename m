Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3JKShe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:37:34 -0400
Received: from mail-gg0-f176.google.com ([209.85.161.176]:56275 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3JKShd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:37:33 -0400
X-Greylist: delayed 3831 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2013 14:37:33 EDT
Date: Fri, 11 Oct 2013 15:37:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V6 1/8] perf tools: validate kcore module addresses
Message-ID: <20131011183720.GR28369@ghostprotocols.net>
References: <20131011182833.GQ28369@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131011182833.GQ28369@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more, looking into it...


  CC       /tmp/build/perf/util/symbol-elf.o
cc1: warnings being treated as errors
util/symbol-elf.c: In function ‘copy_bytes’:
util/symbol-elf.c:1021: error: not protecting local variables: variable
length buffer
make[1]: *** [/tmp/build/perf/util/symbol-elf.o] Error 1
make: *** [install] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@fedora12 linux]$ 

