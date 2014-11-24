Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaKXU1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:27:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53031 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaKXU1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:27:44 -0500
Date: Mon, 24 Nov 2014 15:27:40 -0500 (EST)
Message-Id: <20141124.152740.1226649067585496281.davem@davemloft.net>
To: albeu@free.fr
Cc: netdev@vger.kernel.org, ben@decadent.org.uk, ebiederm@xmission.com,
        bhelgaas@google.com, benoit.taine@lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8139too: The maximum MTU should allow for VLAN headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416744476-7372-1-git-send-email-albeu@free.fr>
References: <1416744476-7372-1-git-send-email-albeu@free.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Nov 2014 12:27:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Bedel <albeu@free.fr>
Date: Sun, 23 Nov 2014 13:07:54 +0100

> As pointed out by Ben Hutchings drivers that allow using VLAN have to
> provide enough headroom for the VLAN tags.
> 
> Signed-off-by: Alban Bedel <albeu@free.fr>

Applied to net-next, but I shouldn't have to guess around about what
tree your patch is for.

In the future you must specify explicitly what tree your patch is
targetted at by saying either "[PATCH net] " or "[PATCH net-next] "
in your subject line.

Thanks.
