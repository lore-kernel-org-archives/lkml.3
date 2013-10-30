Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3J3Pk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:40:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47236 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3J3PkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:40:24 -0400
Date: Wed, 30 Oct 2013 16:40:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Chen Gang <gang.chen@asianux.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/wait.h: add ';' for the statement which
 missed it.
Message-ID: <20131030154015.GN16117@laptop.programming.kicks-ass.net>
References: <52708623.504@asianux.com>
 <52712293.90808@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52712293.90808@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 08:15:31AM -0700, Randy Dunlap wrote:
> On 10/29/13 21:08, Chen Gang wrote:
> > Add ';' for the statement, or can not pass compiling. The related error
> > (for powerpc allmodconfig):
> > 
> >     CC      block/blk-mq.o
> >   block/blk-mq.c: In function ‘blk_mq_queue_enter’:
> >   block/blk-mq.c:108:8: error: expected ‘;’ before ‘__ret’
> >   block/blk-mq.c:108:6: error: void value not ignored as it ought to be
> > 
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> I have that same patch on my machine but never posted it.

tip already includes commit 92ec11809565cf6429c75204e99e0f583b5c9d7c
from the 23th which should fix this.
