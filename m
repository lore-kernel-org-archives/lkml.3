Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab3INPzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 11:55:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab3INPzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 11:55:51 -0400
Message-ID: <523486E4.3000206@redhat.com>
Date: Sat, 14 Sep 2013 11:55:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: dhillf@sina.com
CC: Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [RFC PATCH] mm: numa: adjust hinting fault record if page is
 migrated
References: <20130914115335.3AA33428001@webmail.sinamail.sina.com.cn>
In-Reply-To: <20130914115335.3AA33428001@webmail.sinamail.sina.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2013 07:53 AM, Hillf Danton wrote:
> After page A on source node is migrated to page B on target node, hinting
> fault is recorded on the target node for B. On the source node there is
> another record for A, since a two-stage filter is used when migrating pages.
> 
> Page A is no longer used after migration, so we have to erase its record.

What kind of performance changes have you observed with this patch?

What benchmarks have you run, and on what kind of systems?

-- 
All rights reversed
