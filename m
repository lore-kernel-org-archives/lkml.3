Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaAVXu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:50:57 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41722 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbaAVXu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:50:56 -0500
MIME-Version: 1.0
In-Reply-To: <20B8A056-FE5B-4062-A043-6E34C45B34B8@fb.com>
References: <20140116143749.GA21526@ghostprotocols.net> <CEFDA8E4.2D359%gjain@fb.com>
 <87sisn6ojf.fsf@sejong.aot.lge.com> <20B8A056-FE5B-4062-A043-6E34C45B34B8@fb.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 22 Jan 2014 23:50:35 +0000
X-Google-Sender-Auth: _ir9Etx5pi56p8HTpzhI9nWCdeE
Message-ID: <CAM9d7ciasrmauzZCQmFKkeNhdOjvi4h_d9ziis_RqUM_eH5M_g@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
To: Gaurav Jain <gjain@fb.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gaurav,

On Wed, Jan 22, 2014 at 11:43 PM, Gaurav Jain <gjain@fb.com> wrote:
>> On Jan 17, 2014, at 2:44 AM, "Namhyung Kim" <namhyung@kernel.org> wrote:
>> What I wasn't sure is whether JIT program also produces some dynamic data.
>> And I think only perf mem command cares about data mappings, no?
>
> I don't think we generate symbols for dynamic data at the moment. There may be uses in the future. I don't know about other JIT programs.
>
> If we can include this behaviour it would be great, but I don't have a way to test it. I'd guess if somebody had a valid use case, they would report the issue. Otherwise, the patch as you've written it works great for me.

Thanks for confirming it and testing the patch!

Thanks,
Namhyung
