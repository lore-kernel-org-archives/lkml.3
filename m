Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab3HNWIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:08:19 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41418 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115Ab3HNWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:08:18 -0400
Date: Thu, 15 Aug 2013 00:08:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
Message-ID: <20130814220816.GD19750@two.firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
 <20130814182745.GB19640@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814182745.GB19640@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought I fixed this for good in
> 	commit 114276ac0a3beb9c391a410349bd770653e185ce
> 	Author: Michael S. Tsirkin <mst@redhat.com>
> 	Date:   Sun May 26 17:32:13 2013 +0300
> 	    mm, sched: Drop voluntary schedule from might_fault()

You're right this was an older kernel. So you already fixed
part of it. Great.

I'll remove those parts.

-Andi

