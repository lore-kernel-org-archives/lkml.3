Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965100Ab3DHU4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:56:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52840 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892Ab3DHU4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:56:36 -0400
Date: Mon, 08 Apr 2013 16:56:34 -0400 (EDT)
Message-Id: <20130408.165634.559631606627992397.davem@davemloft.net>
To: lars@metafoo.de
Cc: ben-linux@fluff.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: ks8851: Use dev_pm_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365327184-22956-2-git-send-email-lars@metafoo.de>
References: <1365327184-22956-1-git-send-email-lars@metafoo.de>
	<1365327184-22956-2-git-send-email-lars@metafoo.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 08 Apr 2013 13:56:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>
Date: Sun,  7 Apr 2013 11:33:04 +0200

> Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied.
