Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab3CFPks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:40:48 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:63785 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009Ab3CFPkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:40:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130306153752.GA19141@krava.redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
	<CAFTL4hyBN=pBao_AnrXsAj06t534hyO=3mpc=1_yM0feO0=gRw@mail.gmail.com>
	<20130306153752.GA19141@krava.redhat.com>
Date: Wed, 6 Mar 2013 16:40:46 +0100
Message-ID: <CAFTL4hzpRK9tTY06nWJ7LWn13Bf2wewru4-1W3wbtDkJry5X4A@mail.gmail.com>
Subject: Re: [PATCHv2] perf: Fix vmalloc ring buffer free function
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/6 Jiri Olsa <jolsa@redhat.com>:
> nope, because CONFIG_PERF_USE_VMALLOC rb uses only 1st slot
> of rg->data_pages[], so rb->nr_page is either 0 or 1
>
> the actuall number of pages is counted via rb->page_order
> (which is -1 for case with no data pages)

Ah right.
