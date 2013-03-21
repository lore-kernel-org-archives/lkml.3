Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3CUTzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:55:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab3CUTzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:55:15 -0400
Message-ID: <514B6501.80102@redhat.com>
Date: Thu, 21 Mar 2013 15:52:33 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] mm: vmscan: Check if kswapd should writepage once
 per priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-10-git-send-email-mgorman@suse.de>
In-Reply-To: <1363525456-10448-10-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2013 09:04 AM, Mel Gorman wrote:
> Currently kswapd checks if it should start writepage as it shrinks
> each zone without taking into consideration if the zone is balanced or
> not. This is not wrong as such but it does not make much sense either.
> This patch checks once per priority if kswapd should be writing pages.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

