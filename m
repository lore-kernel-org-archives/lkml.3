Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297Ab3ECUNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:13:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48184 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934274Ab3ECUNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:13:42 -0400
Date: Fri, 03 May 2013 16:13:40 -0400 (EDT)
Message-Id: <20130503.161340.725942468744060225.davem@davemloft.net>
To: cascardo@linux.vnet.ibm.com
Cc: netdev@vger.kernel.org, dm@chelsio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb4: fix error recovery when t4_fw_hello returns a
 positive value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367604664-22368-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1367604664-22368-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 03 May 2013 13:13:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Fri,  3 May 2013 15:11:04 -0300

> Since commit 636f9d371f70f22961fd598fe18380057518ca31 ("cxgb4: Add
> support for T4 configuration file"), t4_fw_hello may return a positive
> value instead of 0 for success. The recovery code tests only for zero
> and fails recovery for any other value.
> 
> This fix tests for negative error values and fails only on those cases.
> Error recovery after an error injection works after this change.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

Applied.
