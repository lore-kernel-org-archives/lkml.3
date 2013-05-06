Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3EFQPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 12:15:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:50394 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3EFQPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 12:15:21 -0400
Message-ID: <5187D6F1.9070103@infradead.org>
Date: Mon, 06 May 2013 09:14:41 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Smart <james.smart@emulex.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: linux-next: Tree for May 6 (lpfc)
References: <20130506144207.c812a0227d7763d26e5fec80@canb.auug.org.au>
In-Reply-To: <20130506144207.c812a0227d7763d26e5fec80@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/13 21:42, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any v3.11 destined work to your linux-next included
> branches until after v3.10-rc1 is released.
> 
> I am receiving a (un)reasonable number of conflicts from there being
> multiple copies of some commits in various trees.   Please clean this up
> and resist the temptataion to rebase your trees on the way to your
> upstream ...
> 
> Changes since 20130506:
> 

on i386:
# CONFIG_CRC_T10DIF is not set


drivers/built-in.o: In function `lpfc_bg_crc':
(.text+0x3cb3c9): undefined reference to `crc_t10dif'




-- 
~Randy
