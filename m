Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaJCIKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:10:41 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:52349 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaJCIKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:10:30 -0400
Message-ID: <1412323827.6015.10.camel@haakon3.risingtidesystems.com>
Subject: Re: linux-next: build failure after merge of the target-updates tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 03 Oct 2014 01:10:27 -0700
In-Reply-To: <20141003154629.3b64e021@canb.auug.org.au>
References: <20141003154629.3b64e021@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 15:46 +1000, Stephen Rothwell wrote:
> Hi Nicholas,
> 
> After merging the target-updates tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/target/target_core_user.c: In function 'tcmu_netlink_event':
> drivers/target/target_core_user.c:780:2: error: expected ';' before 'ret'
>   ret = nla_put_u32(skb, TCMU_ATTR_MINOR, minor);
>   ^
> 
> Caused by commit 7f2ea21b2c8d ("target/user: Fix up smatch warnings in
> tcmu_netlink_event").
> 
> I have reverted that commit for today.

Fixed.  Thank you Stephen.

--nab


