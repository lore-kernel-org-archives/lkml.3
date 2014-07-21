Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaGUEbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 00:31:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53268 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaGUEbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 00:31:03 -0400
Date: Sun, 20 Jul 2014 21:31:02 -0700 (PDT)
Message-Id: <20140720.213102.1007291311502673484.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, joe@perches.com, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, e1000-devel@lists.sourceforge.net,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/30] drivers/net: remove unnecessary break after
 return
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405865801-18806-1-git-send-email-fabf@skynet.be>
References: <1405865801-18806-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 20 Jul 2014 21:31:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Sun, 20 Jul 2014 16:16:08 +0200

> Second patchset after "remove unnecessary break after goto" addressing break redundancy on drivers/net branch
> (suggested by Joe Perches)

All applied except the i40e patch, which did not apply to net-next at all.
