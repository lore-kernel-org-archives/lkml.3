Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaADDEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 22:04:46 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27194 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaADDEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 22:04:45 -0500
Message-ID: <52C779EE.7070403@oracle.com>
Date: Fri, 03 Jan 2014 22:03:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>, Bob Liu <bob.liu@oracle.com>,
        Nick Piggin <npiggin@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
References: <1387267550-8689-1-git-send-email-liwanp@linux.vnet.ibm.com>	<52b1138b.0201430a.19a8.605dSMTPIN_ADDED_BROKEN@mx.google.com>	<52B11765.8030005@oracle.com>	<52b120a5.a3b2440a.3acf.ffffd7c3SMTPIN_ADDED_BROKEN@mx.google.com>	<52B166CF.6080300@suse.cz>	<52b1699f.87293c0a.75d1.34d3SMTPIN_ADDED_BROKEN@mx.google.com>	<20131218134316.977d5049209d9278e1dad225@linux-foundation.org>	<52C71ACC.20603@oracle.com>	<CA+55aFzDcFyyXwUUu5bLP3fsiuzxU7VPivpTPHgp8smvdTeESg@mail.gmail.com>	<52C74972.6050909@suse.cz> <20140103155600.ce7194bb8b33d5581b05a162@linux-foundation.org>
In-Reply-To: <20140103155600.ce7194bb8b33d5581b05a162@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 06:56 PM, Andrew Morton wrote:
> Nobody answered my question!  Is this a new bug or is it a
> five-year-old bug which we only just discovered?

I've rolled trinity back and was unable to reproduce this issue anymore. This
seems to be a 5 year old bug.


Thanks,
Sasha
