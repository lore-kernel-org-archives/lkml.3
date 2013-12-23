Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab3LWMLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 07:11:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868Ab3LWMLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 07:11:21 -0500
Date: Mon, 23 Dec 2013 13:11:14 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Chunwei Chen <tuxoko@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] perf config: ignore generated files in feature-checks
Message-ID: <20131223121114.GA23099@krava.brq.redhat.com>
References: <1387441761-2153-1-git-send-email-tuxoko@gmail.com>
 <20131219115833.GA11279@gmail.com>
 <CAK1sfuYn1iLUHWwUTdm755D0YpuAcROsj5rp=4-Vg5qc57bFfw@mail.gmail.com>
 <20131219154642.GA24658@gmail.com>
 <CAK1sfubfVtqfoKMpeB1h+ooq0+ogJvM0FFDu1Wyc9i16CqGfaw@mail.gmail.com>
 <20131219171027.GD30382@gmail.com>
 <52B3C4A8.3070809@gmail.com>
 <20131220163413.GB17780@ghostprotocols.net>
 <52B52B9B.50708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B52B9B.50708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 01:48:11PM +0800, Chunwei Chen wrote:
> From ce62a386df25ec50e13487c7b56e09c71c2abf4c Mon Sep 17 00:00:00 2001
> From: Chunwei Chen <tuxoko@gmail.com>
> Date: Sat, 21 Dec 2013 13:15:07 +0800
> Subject: [PATCH] perf config: ignore generated files in feature-checks

seems superfluous ^^^

> 
> 1. Rename the test-* binary files to test-*.bin for easier pattern matching as
>    suggested by Ingo.
> 2. Ignore *.bin and *.d files.
> 
> Signed-off-by: Chunwei Chen <tuxoko@gmail.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
