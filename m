Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaAVXoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:44:55 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:62907 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaAVXoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:44:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140122132018.GC1132@krava.brq.redhat.com>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org> <20140122132018.GC1132@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 22 Jan 2014 23:44:33 +0000
X-Google-Sender-Auth: mLpVHtubGz3Zp8p9ReduG8EoKvk
Message-ID: <CAM9d7cj=5JnY+yLnNpR2Ex+_dbfcZCjup0Sa2tBf84DcoYHEHA@mail.gmail.com>
Subject: Re: [PATCHSET 00/24] perf tools: Add support to accumulate hist
 periods (v6)
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, Jan 22, 2014 at 1:20 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> I have changes on top of this patchset and all looks great, I was
> just going throught this again and wanted to send my ack, but it
> no longer merges to the acme's perf/core.

Thanks, but wasn't it applied to the acme/perf/core?  Now I'm rebasing
it onto the acme/perf/core and it applies without any conflicts.  Did
you see one?

>
> Could you please send updated version, and I'll finish the
> review.. I promise ;-)

Thanks in advance, I'll send out the v7 right soon. :)

-- 
Thanks,
Namhyung
