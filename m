Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaETC3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:29:53 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:44253 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaETC3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:29:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140519151120.GE24333@sdfg.com.ar>
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org> <20140519151120.GE24333@sdfg.com.ar>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 20 May 2014 02:29:31 +0000
X-Google-Sender-Auth: lDJ5zahD05yMyRzzbLvOAQL5Hnw
Message-ID: <CAM9d7cjVpFL0Vx48Pq6vR5OfnAvCAn7YkkJJS=bm6UqU=W5TOw@mail.gmail.com>
Subject: Re: [PATCHSET 00/21] perf tools: Add support to accumulate hist
 periods (v9)
To: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodrigo,

On Mon, May 19, 2014 at 3:11 PM, Rodrigo Campos <rodrigo@sdfg.com.ar> wrote:
> Is there something I can help to have this merged ? As far as I tested, this
> works fine here. Or is this ok, just waiting on the "perf report: Add -F option for
> specifying output fields" patchset ?

Thanks for testing!!  As I never got (negative) feedbacks or reviews
so far, I'd assume it's ok. :)  But as you said, it should wait for
the output field option merged which I hope to be done soon.  I'll
update and report this once it's done.

Thanks,
Namhyung
