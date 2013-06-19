Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677Ab3FSMQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:16:42 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:43503 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab3FSMQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:16:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130619113326.GA9119@gmail.com>
References: <1371603750-15053-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com> <20130619113326.GA9119@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 19 Jun 2013 21:16:20 +0900
X-Google-Sender-Auth: KNqVhy2w-oet8xnDEIQP33lyNgI
Message-ID: <CAM9d7cjpHEoZaMQE_y5+b1+PZvXrAarzrjtd_GHaNgy1ODy0mQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf tools: include termios.h explicitly
To: Ingo Molnar <mingo@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, Jun 19, 2013 at 8:33 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
>
>> Building perf for android is failed, because it can't find definition of
>> struct winsize. This definition is in termios.h, so I add this header
>> to util.h to solve the problem. It is missed by commit '2c803e52' which
>> moves get_term_dimensions() from builtin-top.c to util.c, but, missed to
>> move termios.h header.
>>
>> Cc: David Ahern <dsahern@gmail.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> Is this something we need for v3.10 as well?
>
> Thanks,
>
>         Ingo

I think it's good to go to v3.10 and even v3.9 as well:

 $ git name-rev --tags --refs=refs/tags/v3.* 2c803e52
 2c803e52 tags/v3.9-rc1~173^2~13^2~22

--
Thanks,
Namhyung
