Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaCOPtH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:49:07 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:48183 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaCOPtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:49:05 -0400
Message-ID: <5324766D.7080407@gmail.com>
Date: Sat, 15 Mar 2014 09:49:01 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/4] perf: trivial follow-ons to --list-cmds
References: <1394853474-31019-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1394853474-31019-1-git-send-email-artagnon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/14, 9:17 PM, Ramkumar Ramachandra wrote:
> Hi,
>
> With "perf kvm: introduce --list-cmds for use by scripts" accepted,
> these are trivial follow-on patches to enable the same functionality
> in kmem, mem, lock, and sched.
>
> Thanks.
>
> Ramkumar Ramachandra (4):
>    perf kmem: introduce --list-cmds for use by scripts
>    perf mem: introduce --list-cmds for use by scripts
>    perf lock: introduce --list-cmds for use by scripts
>    perf sched: introduce --list-cmds for use by scripts
>

All 4 look good to me.

Acked-by: David Ahern <dsahern@gmail.com>
