Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3HOVGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:06:46 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:61243 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3HOVGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:06:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130815134348.bb119a7987af0bb64ed77b7b@linux-foundation.org>
References: <1376545589-32129-1-git-send-email-yinghai@kernel.org>
	<20130815134348.bb119a7987af0bb64ed77b7b@linux-foundation.org>
Date: Thu, 15 Aug 2013 14:06:44 -0700
X-Google-Sender-Auth: ejwCcWqbjDg7Af1R_MFaD4JX-Nk
Message-ID: <CAE9FiQUyGpmMP0VPE5ZrvDMLB-sdb0DzajGvB_KDt-ZnoJZhPg@mail.gmail.com>
Subject: Re: [PATCH] memblock, numa: Binary search node id
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Russ Anderson <rja@sgi.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 1:43 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 14 Aug 2013 22:46:29 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Current early_pfn_to_nid() on arch that support memblock go
>> over memblock.memory one by one, so will take too many try
>> near the end.
>>
>> We can use existing memblock_search to find the node id for
>> given pfn, that could save some time on bigger system that
>> have many entries memblock.memory array.
>
> Looks nice.  I wonder how much difference it makes.

Russ said he would test on his 256 nodes system, but looks he never
got chance.

Thanks

Yinghai
