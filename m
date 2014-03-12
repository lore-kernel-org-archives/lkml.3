Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaCLT2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:28:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40479 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaCLT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:28:40 -0400
Date: Wed, 12 Mar 2014 15:28:39 -0400 (EDT)
Message-Id: <20140312.152839.798485560031245185.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] net: Convert uses of __constant_<foo> to
 <foo>
From: David Miller <davem@davemloft.net>
In-Reply-To: <5bc6ebcb56edc59ea478416474fbbe52200a8cb2.1394643455.git.joe@perches.com>
References: <cover.1394643455.git.joe@perches.com>
	<5bc6ebcb56edc59ea478416474fbbe52200a8cb2.1394643455.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Mar 2014 12:28:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 12 Mar 2014 10:04:17 -0700

> The use of __constant_<foo> has been unnecessary for quite awhile now.
> 
> Make these uses consistent with the rest of the kernel.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
