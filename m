Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3JDNoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:44:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:21478 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab3JDNoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:44:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1033,1371106800"; 
   d="scan'208";a="414024234"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Thread-Topic: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Thread-Index: AQHOv4QLcKrfhiX4106LS7dZ0ASSH5nhidXggAMFveA=
Date: Fri, 4 Oct 2013 13:44:10 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211B0135@FMSMSX107.amr.corp.intel.com>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
 <32E1700B9017364D9B60AED9960492BC211AEF75@FMSMSX107.amr.corp.intel.com>
 <20131002152811.GC32181@quack.suse.cz>
 <32E1700B9017364D9B60AED9960492BC211AF005@FMSMSX107.amr.corp.intel.com>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211AF005@FMSMSX107.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The PSM side of the code is a more traditional use of GUP (like direct I/O), so
> I think it is a different use case than the locking for IB memory regions.

I have resubmitted the two deadlock fixes using get_user_pages_fast() and marked them stable.

See http://marc.info/?l=linux-rdma&m=138089335506355&w=2

Mike
