Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbaITTBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 15:01:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50692 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbaITTBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 15:01:42 -0400
Date: Sat, 20 Sep 2014 21:01:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH 6/7] sched: Delete rq::skip_clock_update == -1
Message-ID: <20140920190139.GW2832@worktop.localdomain>
References: <20140920165116.16299.1381.stgit@localhost>
 <20140920165146.16299.20907.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140920165146.16299.20907.stgit@localhost>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 08:51:46PM +0400, Kirill Tkhai wrote:
> From: Kirill Tkhai <ktkhai@parallels.com>
> 
> Idle class task is always queued, so we can safely remove "-1" case here.

Tag you're it :-)

https://lkml.org/lkml/2014/4/8/295
