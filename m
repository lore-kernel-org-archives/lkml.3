Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbaGOC1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 22:27:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37437 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaGOC1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 22:27:53 -0400
Date: Mon, 14 Jul 2014 19:27:51 -0700 (PDT)
Message-Id: <20140714.192751.860546525235995890.davem@davemloft.net>
To: olivier@sobrie.be
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] hso: remove unused workqueue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405332530-2507-1-git-send-email-olivier@sobrie.be>
References: <1405332530-2507-1-git-send-email-olivier@sobrie.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Jul 2014 19:27:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olivier Sobrie <olivier@sobrie.be>
Date: Mon, 14 Jul 2014 12:08:49 +0200

> The workqueue "retry_unthrottle_workqueue" is not scheduled anywhere
> in the code. So, remove it.
> 
> Signed-off-by: Olivier Sobrie <olivier@sobrie.be>

Applied.
