Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163Ab3DAVye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:54:34 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:60373 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3DAVyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:54:33 -0400
Subject: Re: [PATCH 03/27] perf tools: Move arch check into config/Makefile
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>
In-Reply-To: <1364843930-17974-4-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
	 <1364843930-17974-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Apr 2013 06:54:26 +0900
Message-ID: <1364853266.1728.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri

2013-04-01 (월), 21:18 +0200, Jiri Olsa:
> Moving arch check into config/Makefile.

[SNIP]

> +ifeq ($(filter clean tags,$(MAKECMDGOALS)),)
> +include config/Makefile
>  endif

Problem with this approach is that people (including me) sometimes give
multiple targets in one go - like "make clean all".

Thanks,
Namhyung


