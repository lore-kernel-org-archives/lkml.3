Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbaHAR1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:27:16 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64725 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaHAR1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140801123225.GA6728@localhost>
References: <20140730140235.GA13959@localhost>
	<20140801123225.GA6728@localhost>
Date: Fri, 1 Aug 2014 10:27:13 -0700
Message-ID: <CAM_iQpVz_UsFfyv2kjDbgt=KgSQHS8G6mEmjM63rvFnTFjDmoQ@mail.gmail.com>
Subject: Re: [cxgb4i] INFO: suspicious RCU usage. ]
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Anish Bhatt <anish@chelsio.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>,
        "Lu, Aaron" <aaron.lu@intel.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 5:32 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Anish,
>
> FYI, here is one more bug message for
>
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 759a0cc5a3e1bc2cc48fa3c0b91bdcad8b8f87d6 ("cxgb4i: Add ipv6 code to driver, call into libcxgbi ipv6 api")
>

I don't see the point of holding rcu read lock in cxgbi_inet6addr_handler(),
I think we can just remove it.
