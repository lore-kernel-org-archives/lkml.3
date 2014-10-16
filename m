Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaJPD0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:26:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56251 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaJPD0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:26:03 -0400
Date: Wed, 15 Oct 2014 23:26:01 -0400 (EDT)
Message-Id: <20141015.232601.1795517855303731790.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, pshelar@nicira.com, dev@openvswitch.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] openvswitch: use vport instead of p
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413399821-8558-1-git-send-email-fabf@skynet.be>
References: <1413399821-8558-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Oct 2014 20:26:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed, 15 Oct 2014 21:03:41 +0200

> All functions used struct vport *vport except
> ovs_vport_find_upcall_portid.
> 
> This fixes 1 kerneldoc warning
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
