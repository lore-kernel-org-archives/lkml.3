Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaGNOK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:10:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbaGNOKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:10:21 -0400
Message-ID: <53C3E4BE.2010505@redhat.com>
Date: Mon, 14 Jul 2014 10:10:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mm: vmscan: remove all_unreclaimable() fix
References: <1405344049-19868-1-git-send-email-hannes@cmpxchg.org> <1405344049-19868-3-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1405344049-19868-3-git-send-email-hannes@cmpxchg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/14/2014 09:20 AM, Johannes Weiner wrote:
> As per Mel, use bool for reclaimability throughout and simplify
> the reclaimability tracking in shrink_zones().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Rik van Riel <riel@redhat.com>


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTw+S+AAoJEM553pKExN6DtvYH/RXaEx/lWC9UR5eRQ8nQy2L4
V87wVoWPXauuIeJrGurTV28cvqUW/JXNAmnONuGdRI//9jE2vMZmVi2X5V4CnGv2
zpMsM2MhIn7tzBKW7AlBLHBC9nUEIHpo+OA3IvCvQsgG5qWNkdWOTUv1xkiqTuuQ
Nu7pxiNH360Dp+g2VCuFU2+nrjcKKSolsMBqEvGGP+Dh3/G5EQpQ/lQJ0/a/4q1y
/ew0HCYRfH2/kCMKxixTtUXR7QcMw4L4AkD0fHoisRoyuVAws4QwYA4zB1FKpxgr
XIsVPLftQc8f+++Djone+RvPaPmUOvXrf8UdbxTG5wrfBJ9aPB5AuecWqOOO22g=
=3M3e
-----END PGP SIGNATURE-----
