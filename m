Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaBYXf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:35:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58566 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBYXfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:35:55 -0500
Date: Tue, 25 Feb 2014 18:35:53 -0500 (EST)
Message-Id: <20140225.183553.280525429605913122.davem@davemloft.net>
To: cascardo@linux.vnet.ibm.com
Cc: netdev@vger.kernel.org, dm@chelsio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/cxgb4: use remove handler as shutdown handler
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393272292-11268-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1393272292-11268-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2014 15:35:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Mon, 24 Feb 2014 17:04:52 -0300

> Without a shutdown handler, T4 cards behave very badly after a kexec.
> Some firmware calls return errors indicating allocation failures, for
> example. This is probably because thouse resources were not released by
> a BYE message to the firmware, for example.
> 
> Using the remove handler guarantees we will use a well tested path.
> 
> With this patch I applied, I managed to use kexec multiple times and
> probe and iSCSI login worked every time.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

Applied.
