Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaAVXrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:47:09 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60802 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaAVXrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:47:07 -0500
MIME-Version: 1.0
In-Reply-To: <52E00800.90305@fb.com>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
 <20140122132018.GC1132@krava.brq.redhat.com> <52E00800.90305@fb.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 22 Jan 2014 23:46:46 +0000
X-Google-Sender-Auth: MAbqACj_Y_zxFDzFu13vy7KsCuo
Message-ID: <CAM9d7cgdF+ZE7oa-XeLSO6y=z8sT3mczmnirAZdGY71yb-kkMw@mail.gmail.com>
Subject: Re: [PATCHSET 00/24] perf tools: Add support to accumulate hist
 periods (v6)
To: Arun Sharma <asharma@fb.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,

On Wed, Jan 22, 2014 at 6:03 PM, Arun Sharma <asharma@fb.com> wrote:
> On 1/22/14 5:20 AM, Jiri Olsa wrote:
>
>> I have changes on top of this patchset and all looks great, I was
>> just going throught this again and wanted to send my ack, but it
>> no longer merges to the acme's perf/core.
>>
>> Could you please send updated version, and I'll finish the
>> review.. I promise ;-)
>
>
> We've been testing v5 of this patch series and haven't found any major
> problems on our end.
>
> Tested-By: Arun Sharma <asharma@fb.com>

Thanks for your testing!
Namhyung
