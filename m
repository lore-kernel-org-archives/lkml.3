Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbaJaMPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 08:15:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758182AbaJaMPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 08:15:41 -0400
Message-ID: <54537D20.2080203@redhat.com>
Date: Fri, 31 Oct 2014 08:14:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: w00218164 <weiyuan.wei@huawei.com>, akpm@linux-foundation.org,
        mgorman@suse.de, rientjes@google.com, hannes@cmpxchg.org,
        vbabka@suse.cz, sasha.levin@oracle.com
CC: lizefan@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix a spelling mistake
References: <1414751873-19981-1-git-send-email-weiyuan.wei@huawei.com>
In-Reply-To: <1414751873-19981-1-git-send-email-weiyuan.wei@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/31/2014 06:37 AM, w00218164 wrote:
> From: Wei Yuan <weiyuan.wei@huawei.com>
> 
> This patch fixes a spelling mistake in func __zone_watermark_ok,
> which may was wrongly spelled my.
> 
> Signed-off-by Wei Yuan <weiyuan.wei@huawei.com>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUU30gAAoJEM553pKExN6DuYEH/A//pb6HSRmQJAkRiQC3PQ/X
Qq8MRDyRiXznoHks6Xd/gbAVGpbLftTXApL+6zKL7Id8CSE8qqvJ2wOg6zuLaoyf
4KpCaPahKF6LVNGLdy8hK0OnR65iM6KnUZNHfPCPfA9FU7oDknuW6+Ryt3RqrF83
bEgczxDfv8p4+24GHhX+UODCOktIxS65Nm3zfRYmNcoMnoIRfgCJZIbjF8Ah5LBY
/0RWAjDAJwvpCZB6wwnttXOJlKhRPx77dnKjkMFJgjxDaplq9hSkKG+EzEqztFEi
n8gtvPCHGQovxctjjv/AFFP0o0mvkl5O/f4V/BChC2Bih7Z6pEvlAwo9SwbKqvU=
=OxmS
-----END PGP SIGNATURE-----
