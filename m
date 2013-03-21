Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab3CUOmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:42:08 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:36284 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3CUOmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:42:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130321142254.GA2992@linux.vnet.ibm.com>
References: <20130314205307.GA27968@linux.vnet.ibm.com>
	<20130321142254.GA2992@linux.vnet.ibm.com>
Date: Thu, 21 Mar 2013 07:42:03 -0700
X-Google-Sender-Auth: MxKfcmAiIzYiRYiQfB3-PASGNwg
Message-ID: <CA+55aFzk3XZSX6WWsZAyUqYO5qvZWN5dTvMr2==So25h9V79ew@mail.gmail.com>
Subject: Re: [GIT PULL tip/core/urgent] Fix for hlist_entry_safe() regression
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        CAI Qian <caiqian@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        lizefan@huawei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 7:22 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> [Reposting with corrected subject line.]
>
> Hello, Ingo,
>
> This series contains a single commit that fixes a regression in
> hlist_entry_safe().  ..

You do realize that I already merged this a week ago directly? (Merge
commit f4846e52c517)

             Linus
