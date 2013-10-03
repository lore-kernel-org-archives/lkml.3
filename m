Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab3JCFGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:06:49 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51310 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3JCFGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:06:46 -0400
MIME-Version: 1.0
In-Reply-To: <524C1964.8090205@gmail.com>
References: <CALkWK0mmUZe-Wv2H2Z3y9FN0_kYv9gKaaXkMQ0UD-J9Q+=wFzQ@mail.gmail.com>
 <524C1964.8090205@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 3 Oct 2013 10:36:05 +0530
Message-ID: <CALkWK0kzXnBKiRyN5HPE-_nScOG-JKjAnD1ujxA_R8tWQWrxZQ@mail.gmail.com>
Subject: Re: [QUERY] Why does perf-trace need me to be root?
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern wrote:
> If you trust your users make the debugfs mount point rx by group,world.

Thanks David. I can preserve this configuration across reboots by
putting an entry in fstab, right? How do I preserve the value of
/proc/sys/kernel/perf_event_paranoid across reboots?
