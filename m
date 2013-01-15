Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab3AOEsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:48:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38545 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3AOEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:48:11 -0500
Date: Mon, 14 Jan 2013 23:48:07 -0500 (EST)
Message-Id: <20130114.234807.263597221162955409.davem@davemloft.net>
To: harvey.huawei.yang@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: ipv4: refine the logic for determining daddr
 in ip_queue_xmit.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358225255-30973-1-git-send-email-harvey.huawei.yang@gmail.com>
References: <1358225255-30973-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Yang <harvey.huawei.yang@gmail.com>
Date: Tue, 15 Jan 2013 12:47:35 +0800

> The destination address daddr is faddr if source route option is set, otherwise it is inet_daddr. So use if-else to assign the value.
> 
> Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>

You are changing nothing in how this code behaves.  And stylistically
I know it was coded this way on purpose, because I'm pretty sure I
wrote it.
