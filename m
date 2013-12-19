Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3LSRCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:02:15 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62524 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3LSRCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:02:13 -0500
MIME-Version: 1.0
In-Reply-To: <20131219154642.GA24658@gmail.com>
References: <1387441761-2153-1-git-send-email-tuxoko@gmail.com>
	<20131219115833.GA11279@gmail.com>
	<CAK1sfuYn1iLUHWwUTdm755D0YpuAcROsj5rp=4-Vg5qc57bFfw@mail.gmail.com>
	<20131219154642.GA24658@gmail.com>
Date: Fri, 20 Dec 2013 01:02:11 +0800
Message-ID: <CAK1sfubfVtqfoKMpeB1h+ooq0+ogJvM0FFDu1Wyc9i16CqGfaw@mail.gmail.com>
Subject: Re: [PATCH] perf config: ignore generated files in feature-checks
From: David Chen <tuxoko@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about this:

test-*
!*.c

So that we don't ignore *.c and we don't have to change file name.
Anyway, I'll reupload tomorrow when I have my computer.

Thanks,
Chunwei Chen
