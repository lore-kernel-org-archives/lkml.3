Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3LFEoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 23:44:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33312 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3LFEoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 23:44:22 -0500
Date: Thu, 05 Dec 2013 23:44:20 -0500 (EST)
Message-Id: <20131205.234420.2000965496889063263.davem@davemloft.net>
To: wangyijing@huawei.com
Cc: macro@linux-mips.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        guohanjun@huawei.com
Subject: Re: [PATCH 2/2] net/fddi: Replace local marco with PCI standard
 macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <52A13F34.2010403@huawei.com>
References: <1386243482-32856-1-git-send-email-wangyijing@huawei.com>
	<alpine.LFD.2.10.1312052154190.1599@eddie.linux-mips.org>
	<52A13F34.2010403@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Dec 2013 20:44:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>
Date: Fri, 6 Dec 2013 11:06:28 +0800

> On 2013/12/6 6:06, Maciej W. Rozycki wrote:
>> On Thu, 5 Dec 2013, Yijing Wang wrote:
>> 
>>> Replace local marco DFX_BUS_PCI with PCI standard marco
>>> dev_is_pci().
>> 
>>  Typos above: marco -> macro
> 
> Sorry for the mistake, David, should i need to resend this patch to fix this typo error?

You have to resubmit all of these conversions again because you posted
them before the net-next tree was even open for submissions.

So you might as well fix the typos etc. while doing so.
