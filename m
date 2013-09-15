Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab3IOBL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 21:11:28 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:46383 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab3IOBL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 21:11:27 -0400
MIME-Version: 1.0
In-Reply-To: <523486E4.3000206@redhat.com>
References: <20130914115335.3AA33428001@webmail.sinamail.sina.com.cn>
	<523486E4.3000206@redhat.com>
Date: Sun, 15 Sep 2013 09:11:24 +0800
Message-ID: <CAJd=RBDhm5ZAQdi4K+JK3FZ-=jaNz6peyLtSxMrBGcGmKX=6qw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: numa: adjust hinting fault record if page is migrated
From: Hillf Danton <dhillf@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: dhillf@sina.com, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rik

On Sat, Sep 14, 2013 at 11:55 PM, Rik van Riel <riel@redhat.com> wrote:
> On 09/14/2013 07:53 AM, Hillf Danton wrote:
>> After page A on source node is migrated to page B on target node, hinting
>> fault is recorded on the target node for B. On the source node there is
>> another record for A, since a two-stage filter is used when migrating pages.
>>
>> Page A is no longer used after migration, so we have to erase its record.
>
> What kind of performance changes have you observed with this patch?
>
> What benchmarks have you run, and on what kind of systems?
>
Due to no NUMA box, I can not answer you now.
I will try best to borrow one next Monday.

Thanks
Hillf
