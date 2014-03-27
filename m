Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaC0AGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:06:39 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48237 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaC0AGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:06:38 -0400
MIME-Version: 1.0
In-Reply-To: <5324766D.7080407@gmail.com>
References: <1394853474-31019-1-git-send-email-artagnon@gmail.com> <5324766D.7080407@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 26 Mar 2014 20:05:57 -0400
Message-ID: <CALkWK0kw85AOtBuF+HfPkR9jCeqSogAnb4vQvez1g+Cgoib1+A@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: trivial follow-ons to --list-cmds
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern wrote:
>> Ramkumar Ramachandra (4):
>>    perf kmem: introduce --list-cmds for use by scripts
>>    perf mem: introduce --list-cmds for use by scripts
>>    perf lock: introduce --list-cmds for use by scripts
>>    perf sched: introduce --list-cmds for use by scripts
>>
>
> All 4 look good to me.
>
> Acked-by: David Ahern <dsahern@gmail.com>

Arnaldo: I noticed that you haven't picked these up yet. Let me know
if they're not okay.

Thanks.

Ram
