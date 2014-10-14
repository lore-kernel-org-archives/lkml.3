Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbaJNUGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:06:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44289 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbaJNUGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:06:04 -0400
Date: Tue, 14 Oct 2014 16:06:02 -0400 (EDT)
Message-Id: <20141014.160602.1746747507486023769.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, joe@perches.com,
        dmitry.tarnyagin@lockless.no, netdev@vger.kernel.org
Subject: Re: [PATCH V2 2/2 net-next] caif_usb: use target structure member
 in memset
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413306074-8401-1-git-send-email-fabf@skynet.be>
References: <1413306074-8401-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Oct 2014 13:06:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue, 14 Oct 2014 19:01:14 +0200

> parent cfusbl was used instead of first structure member 'layer'
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
