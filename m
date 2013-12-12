Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3LLJKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:10:33 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56026 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3LLJKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:10:25 -0500
MIME-Version: 1.0
In-Reply-To: <52A8C36A.9000501@gmail.com>
References: <1386758056-24618-1-git-send-email-artagnon@gmail.com>
 <1386758056-24618-2-git-send-email-artagnon@gmail.com> <20131211195046.GA2295@infradead.org>
 <52A8C36A.9000501@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 12 Dec 2013 14:39:43 +0530
Message-ID: <CALkWK0m=0pJQoCKx+Xc+Do_JwX=NjqwA_wjM8W=spTQm5h5DHQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf completion: complete 'perf kvm'
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern wrote:
> I don't like the command list being embedded in the completion script. It
> will get outdated quickly.

I could introduce a

  $ perf kvm --list-cmds

but that would mean a

  printf("record report stat ..")

in builtin-kvm.c, because the commands aren't in any sort of array.
