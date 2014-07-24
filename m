Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177AbaGXEIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:08:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40420 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaGXEIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:08:34 -0400
Date: Wed, 23 Jul 2014 21:08:31 -0700 (PDT)
Message-Id: <20140723.210831.253096883800350687.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: filter: split eBPF interpreter out
 of core networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406095319-3627-1-git-send-email-ast@plumgrid.com>
References: <1406095319-3627-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Jul 2014 21:08:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Tue, 22 Jul 2014 23:01:57 -0700

> I believe my recent set of RFC/patches [1] provided good visibility on where
> I would like to take eBPF subsystem. These two trivial patches is a first step
> in that direction:
> patch 1 - mechanical split of eBPF interpreter out of filter.c
> patch 2 - nominate myself as a maintainer for eBPF core pieces
> In the foreseeable future eBPF patches will be going through net-next,
> so put netdev as a primary mailing list
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf master

Series applied to net-next.
