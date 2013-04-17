Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3DQSmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:42:52 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:59462 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3DQSmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:42:50 -0400
Message-ID: <1366224294.9379.32.camel@haakon3.risingtidesystems.com>
Subject: Re: linux-next: Tree for Apr 17 (infiniband/rdma)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Date: Wed, 17 Apr 2013 11:44:54 -0700
In-Reply-To: <CAJZOPZJHJ0qKJo=HyEiJq1rRPXg+8bNh+8U_2WhX6FKbE2Km7A@mail.gmail.com>
References: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au>
	 <516EE4BD.3000200@infradead.org>
	 <CAJZOPZJHJ0qKJo=HyEiJq1rRPXg+8bNh+8U_2WhX6FKbE2Km7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-17 at 21:15 +0300, Or Gerlitz wrote:
> On Wed, Apr 17, 2013 at 9:06 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> > On 04/17/13 00:04, Stephen Rothwell wrote:
> >> Changes since 20130416:
> 
> > on x86_64:
> > drivers/built-in.o: In function `isert_free_np':
> > ib_isert.c:(.text+0x6e8a77): undefined reference to `rdma_destroy_id'
> [...]
> 
> Nic,
> 
> Yep, you need to add
> 
> depends on INET &&  INFINIBAND_ADDR_TRANS
> 
> 
> to the isert Kconfig entry
> 
> 
> This will make sure to get the rdma_cm to be configured and builts
> whenever isert is
> 

Thanks Roland & Or, fixing this up now.

--nab

