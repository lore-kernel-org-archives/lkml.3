Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3LSRKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:10:33 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:34821 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3LSRKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:10:32 -0500
Date: Thu, 19 Dec 2013 18:10:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Chen <tuxoko@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf config: ignore generated files in feature-checks
Message-ID: <20131219171027.GD30382@gmail.com>
References: <1387441761-2153-1-git-send-email-tuxoko@gmail.com>
 <20131219115833.GA11279@gmail.com>
 <CAK1sfuYn1iLUHWwUTdm755D0YpuAcROsj5rp=4-Vg5qc57bFfw@mail.gmail.com>
 <20131219154642.GA24658@gmail.com>
 <CAK1sfubfVtqfoKMpeB1h+ooq0+ogJvM0FFDu1Wyc9i16CqGfaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1sfubfVtqfoKMpeB1h+ooq0+ogJvM0FFDu1Wyc9i16CqGfaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Chen <tuxoko@gmail.com> wrote:

> How about this:
> 
> test-*
> !*.c

Still looks a bit too generic to me.

> So that we don't ignore *.c and we don't have to change file name.
> Anyway, I'll reupload tomorrow when I have my computer.

I think we should change the feature test binaries to an easy to match 
pattern.

But either way it works for me.

Thanks,

	Ingo
