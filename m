Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbaDBOz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:55:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58217 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaDBOzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:55:53 -0400
Date: Wed, 2 Apr 2014 15:55:07 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        chenhanxiao <chenhanxiao@cn.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
Message-ID: <20140402155507.1d976144@alan.etchedpixels.co.uk>
In-Reply-To: <20140401121920.50d1dd96c2145acc81561b82@linux-foundation.org>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	<20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>
	<1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>
	<20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>
	<1396308332.18499.25.camel@buesod1.americas.hpqcorp.net>
	<20140331170546.3b3e72f0.akpm@linux-foundation.org>
	<533A5CB1.1@jp.fujitsu.com>
	<20140401121920.50d1dd96c2145acc81561b82@linux-foundation.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why aren't people just setting the sysctl to a petabyte?  What problems
> would that lead to?

Historically - hanging on real world desktop systems when someone
accidentally creates a giant SHM segment and maps it.

If you are running with vm overcmmit set to actually do checks then it
*shouldn't* blow up nowdays.

More to the point wtf are people still using prehistoric sys5 IPC APIs
not shmemfs/posix shmem ?

