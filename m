Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaGNOJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:09:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbaGNOJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:09:41 -0400
Message-ID: <53C3E494.90909@redhat.com>
Date: Mon, 14 Jul 2014 10:09:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: vmscan: rework compaction-ready signaling in
 direct reclaim fix
References: <1405344049-19868-1-git-send-email-hannes@cmpxchg.org> <1405344049-19868-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1405344049-19868-2-git-send-email-hannes@cmpxchg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/14/2014 09:20 AM, Johannes Weiner wrote:
> As per Mel, replace out label with breaks from the loop.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTw+SUAAoJEM553pKExN6Dj4wH/imfBq+85Kpjrw4NQltD+uUt
0pAzt/SX9IfiUcowi/1i1jWUKhMAfrY4SCG14g3ErKnIprMT8oa9ujRGCpnnZud2
eqLDFIHM8BlLNfIOV6a96+i1JpFDLbNL8WBjlew6X7ZDZamUG6j+0XxBOtwVemn6
Yj+cubH6mgPtovGRHdEDnyb4JOw5eue4/vIpumdTak3mnKghRpAxdN5tq7h13e1a
w/tweAWFspYHBkUj6FjeGiXrttNF7ToOy0cJeypZJZJfZFRwHBYStTe81iLa7jld
eNmfr48eLjnHrvZAN+lFm/DPuqU4ISuoCnL9N67OCudLrj8YbBzw8tOYNvff7fw=
=bbE9
-----END PGP SIGNATURE-----
