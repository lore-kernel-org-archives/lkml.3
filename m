Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab3CMQcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:32:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab3CMQck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:32:40 -0400
Message-ID: <5140A9F7.6010401@redhat.com>
Date: Wed, 13 Mar 2013 12:31:51 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmscan: minor cleanup for kswapd
References: <CAJd=RBDPPpqhHh3CJAwkC4J=tukDLErwf6juS+x3irvu3PHdbA@mail.gmail.com>
In-Reply-To: <CAJd=RBDPPpqhHh3CJAwkC4J=tukDLErwf6juS+x3irvu3PHdbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2013 12:05 AM, Hillf Danton wrote:
> The local variable, total_scanned, is no longer used, so clean up now.
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
