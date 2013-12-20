Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3LTIkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:40:40 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55787 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3LTIkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:40:39 -0500
Date: Fri, 20 Dec 2013 09:40:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Chunwei Chen <tuxoko@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf config: ignore generated files in feature-checks
Message-ID: <20131220084035.GA15993@gmail.com>
References: <1387441761-2153-1-git-send-email-tuxoko@gmail.com>
 <20131219115833.GA11279@gmail.com>
 <CAK1sfuYn1iLUHWwUTdm755D0YpuAcROsj5rp=4-Vg5qc57bFfw@mail.gmail.com>
 <20131219154642.GA24658@gmail.com>
 <CAK1sfubfVtqfoKMpeB1h+ooq0+ogJvM0FFDu1Wyc9i16CqGfaw@mail.gmail.com>
 <20131219171027.GD30382@gmail.com>
 <52B3C4A8.3070809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B3C4A8.3070809@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chunwei Chen <tuxoko@gmail.com> wrote:

> From 362201bf3259cc01c99531766395fdba0c0f3789 Mon Sep 17 00:00:00 2001
> From: Chunwei Chen <tuxoko@gmail.com>
> Date: Thu, 19 Dec 2013 15:41:22 +0800
> Subject: [PATCH] perf config: ignore generated files in feature-checks
> 
> 1. Rename the test-* binary files to test-*.bin for easier pattern matching as
>    suggested by Ingo.
> 2. Ignore *.bin and *.d files.
> 
> Signed-off-by: Chunwei Chen <tuxoko@gmail.com>

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks!

	Ingo
