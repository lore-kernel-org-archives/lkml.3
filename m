Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaDVSSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:18:41 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:39369 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaDVSSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:18:40 -0400
Message-ID: <1398190717.2473.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/4] ipc/shm.c: check for ulong overflows in shmat
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org
Date: Tue, 22 Apr 2014 11:18:37 -0700
In-Reply-To: <1398090397-2397-2-git-send-email-manfred@colorfullife.com>
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com>
	 <1398090397-2397-2-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-21 at 16:26 +0200, Manfred Spraul wrote:
> find_vma_intersection does not work as intended if addr+size overflows.
> The patch adds a manual check before the call to find_vma_intersection.
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

