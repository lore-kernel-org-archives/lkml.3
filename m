Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3EUSv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:51:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53564 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3EUSv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:51:56 -0400
Date: Tue, 21 May 2013 11:51:55 -0700 (PDT)
Message-Id: <20130521.115155.1518689243601692174.davem@davemloft.net>
To: daniel.petre@rcs-rds.ro
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip_gre: fix kernel panic with icmp_dest_unreach
From: David Miller <davem@davemloft.net>
In-Reply-To: <D2CA09D3-A93C-48CF-A23B-DC1B76D66818@rcs-rds.ro>
References: <D2CA09D3-A93C-48CF-A23B-DC1B76D66818@rcs-rds.ro>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Submit networking patches to netdev@vger.kernel.org, otherwise no
networking developers will see your work and your patch will not
be queued up in patchwork for applying.
