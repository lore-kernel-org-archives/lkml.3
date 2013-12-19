Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab3LSFPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 00:15:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58940 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3LSFPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 00:15:14 -0500
Date: Thu, 19 Dec 2013 00:15:13 -0500 (EST)
Message-Id: <20131219.001513.1709782271902847928.davem@davemloft.net>
To: borkmann@iogearbox.net
Cc: fengguang.wu@intel.com, gaowanlong@cn.fujitsu.com, ffusco@redhat.com,
        kbuild-all@01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next/master PATCH] lib: fix compile warning in
 hashlib_init
From: David Miller <davem@davemloft.net>
In-Reply-To: <52B24C92.8050201@iogearbox.net>
References: <1387415314-21786-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<20131219011506.GA27326@localhost>
	<52B24C92.8050201@iogearbox.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 18 Dec 2013 21:15:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <borkmann@iogearbox.net>
Date: Thu, 19 Dec 2013 02:32:02 +0100

> On 12/19/2013 02:15 AM, Fengguang Wu wrote:
>> CC the list.
>>
>> On Thu, Dec 19, 2013 at 09:08:34AM +0800, Wanlong Gao wrote:
>>> /git/linux/lib/hash.c: In function 'hashlib_init':
>>> /git/linux/lib/hash.c:35:2: warning: passing argument 1 of
>>> 'setup_arch_fast_hash' from incompatible pointer type [enabled by
>>> default]
>>> /git/linux/include/asm-generic/hash.h:5:20: note: expected 'struct
>>> arch_hash_ops *' but argument is of type 'struct fast_hash_ops *'
>>>
>>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>>> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> 
> That's already in netdev patchwork:
> 
> http://patchwork.ozlabs.org/patch/302908/

And I've applied it, thanks.
