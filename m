Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab3LSUKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:10:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35643 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3LSUKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:10:00 -0500
Date: Thu, 19 Dec 2013 15:09:58 -0500 (EST)
Message-Id: <20131219.150958.1721621193135421738.davem@davemloft.net>
To: speiro@ai2.upv.es
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org, jpr@f6fbb.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] hamradio/yam: fix info leak in ioctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387271191-10355-1-git-send-email-speiro@ai2.upv.es>
References: <1386920767-27962-1-git-send-email-speiro@ai2.upv.es>
	<1387271191-10355-1-git-send-email-speiro@ai2.upv.es>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 12:10:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Salva Peiró <speiro@ai2.upv.es>
Date: Tue, 17 Dec 2013 10:06:30 +0100

> The yam_ioctl() code fails to initialise the cmd field
> of the struct yamdrv_ioctl_cfg. Add an explicit memset(0)
> before filling the structure to avoid the 4-byte info leak.
> 
> Signed-off-by: Salva Peiró <speiro@ai2.upv.es>

Applied and queued up for -stable, thanks.
