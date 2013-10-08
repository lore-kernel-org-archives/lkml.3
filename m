Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3JHIGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:06:34 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:42007 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3JHIG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:06:28 -0400
Date: Tue, 8 Oct 2013 10:06:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 20/50] tools/perf/build: Split out feature check:
 'libslang'
Message-ID: <20131008080624.GA6706@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-21-git-send-email-mingo@kernel.org>
 <5252CA9D.3000805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5252CA9D.3000805@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 10/7/13 5:56 AM, Ingo Molnar wrote:
> 
> >@@ -283,7 +283,7 @@ endif
> >
> >  ifndef NO_GTK2
> >    FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
> >-  ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
> >+  ifneq ($(feature-gtk2), 1)
> >      msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
> >      NO_GTK2 := 1
> >    else
> 
> Looks like the gtk2 change bled in early. this should be with the
> next patch.

Indeed - fixed.

Thanks,

	Ingo
