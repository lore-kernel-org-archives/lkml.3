Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaHNFT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:19:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:41421 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaHNFTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:19:54 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53EC46F6.2070802@lge.com>
Date: Thu, 14 Aug 2014 14:19:50 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
CC: Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Subject: Re: [PATCH 1/2] fs/buffer.c: allocate buffer cache from non-movable
 area
References: <53EC4531.1000904@lge.com> <53EC45FC.7050508@lge.com>
In-Reply-To: <53EC45FC.7050508@lge.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry for a typo at the title.
It is 1/3, not 1/2.
