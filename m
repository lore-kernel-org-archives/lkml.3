Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaJ0UEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:04:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50535 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaJ0UEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:04:46 -0400
Date: Mon, 27 Oct 2014 16:04:43 -0400 (EDT)
Message-Id: <20141027.160443.309710867823001663.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ipx: move extern
 sysctl_ipx_pprop_broadcasting to header file
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414436441-4784-1-git-send-email-fabf@skynet.be>
References: <1414436441-4784-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Oct 2014 13:04:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 27 Oct 2014 20:00:41 +0100

> include ipx.h from sysctl_net_ipx.c
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
