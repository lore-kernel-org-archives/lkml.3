Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbaGOXTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:19:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45493 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933926AbaGOXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:19:04 -0400
Date: Tue, 15 Jul 2014 16:19:03 -0700 (PDT)
Message-Id: <20140715.161903.318866372308191765.davem@davemloft.net>
To: teg@jklm.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 4/4] net: rtnetlink - make create_link take
 name_assign_type
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405348645-1995-4-git-send-email-teg@jklm.no>
References: <1405348645-1995-1-git-send-email-teg@jklm.no>
	<1405348645-1995-4-git-send-email-teg@jklm.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Jul 2014 16:19:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>
Date: Mon, 14 Jul 2014 16:37:25 +0200

> This passes down NET_NAME_USER (or NET_NAME_ENUM) to alloc_netdev(),
> for any device created over rtnetlink.
> 
> v9: restore reverse-christmas-tree order of local variables
> 
> Signed-off-by: Tom Gundersen <teg@jklm.no>

Applied.
