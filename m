Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaJAWeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:34:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37458 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaJAWen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:34:43 -0400
Date: Wed, 01 Oct 2014 18:34:37 -0400 (EDT)
Message-Id: <20141001.183437.1387283987407270369.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, gerrit@erg.abdn.ac.uk, dccp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] net/dccp/proto.c: add __init to
 dccp_mib_init
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412138883-2476-1-git-send-email-fabf@skynet.be>
References: <1412138883-2476-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 15:34:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed,  1 Oct 2014 06:48:03 +0200

> dccp_mib_init is only called by __init dccp_init in same module.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
