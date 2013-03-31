Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3CaXbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 19:31:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49751 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab3CaXbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 19:31:04 -0400
Date: Sun, 31 Mar 2013 19:31:00 -0400 (EDT)
Message-Id: <20130331.193100.1277516238806990183.davem@davemloft.net>
To: sam@ravnborg.org
Cc: wangkefeng.wang@huawei.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc:remove unused declaration smp_boot_cpus()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130329110904.GA2765@merkur.ravnborg.org>
References: <5152E41D.2030901@huawei.com>
	<20130329110904.GA2765@merkur.ravnborg.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 31 Mar 2013 16:31:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 29 Mar 2013 12:09:04 +0100

> On Wed, Mar 27, 2013 at 08:20:45PM +0800, Kefeng Wang wrote:
>> smp_boot_cpus() was replaced smp_prepare_cpus() long ago, and it no
>> longer needed, so delete it.
>> 
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Applied.
