Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3FSRXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:23:18 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:37518 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3FSRXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:23:17 -0400
Date: Wed, 19 Jun 2013 14:23:10 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: namhyung@kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix bench numa compilation
Message-ID: <20130619172310.GA2818@ghostprotocols.net>
References: <8761xd2k1c.fsf@sejong.aot.lge.com>
 <1371466499-28291-1-git-send-email-riccardo.magliocchetti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371466499-28291-1-git-send-email-riccardo.magliocchetti@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -					process_nr, thread_nr, runtime_ns_max / bytes_done, val);
> +				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016llx]\n",
> +					process_nr, thread_nr, runtime_ns_max / bytes_done, (unsigned long long)val);

Shouldn't this use PRIu64?
