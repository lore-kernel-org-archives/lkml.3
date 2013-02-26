Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab3BZBwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:52:45 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48202 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3BZBwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:52:44 -0500
MIME-Version: 1.0
In-Reply-To: <512B677D.1040501@oracle.com>
References: <512B677D.1040501@oracle.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 25 Feb 2013 20:52:24 -0500
X-Google-Sender-Auth: 4WCNAUq78g4NA_agI_ZvVUqrxfY
Message-ID: <CAHGf_=rur29gFs9R9AYeDwnbVBm3b3cOfAn2xyi=mQ+ZbgzEDA@mail.gmail.com>
Subject: Re: mm: BUG in mempolicy's sp_insert
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Dave Jones <davej@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 8:30 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
> I've stumbled on the following BUG:
>
> [13551.830090] ------------[ cut here ]------------
> [13551.830090] kernel BUG at mm/mempolicy.c:2187!
> [13551.830090] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC

Unfortunately, I didn't reproduce this. I'll try it tonight.
