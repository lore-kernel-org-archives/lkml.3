Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaATD4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 22:56:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41095 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaATD4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 22:56:43 -0500
Date: Sun, 19 Jan 2014 19:56:42 -0800 (PST)
Message-Id: <20140119.195642.2067897908175374204.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: document accel_priv parameter for
 __dev_queue_xmit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1390188313-9275-1-git-send-email-jasowang@redhat.com>
References: <1390188313-9275-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 20 Jan 2014 11:25:13 +0800

> To silent "make htmldocs" warning.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied to net-next.
