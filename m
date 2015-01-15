Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbbAOTIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:08:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54233 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbbAOTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:08:39 -0500
Date: Thu, 15 Jan 2015 14:08:36 -0500 (EST)
Message-Id: <20150115.140836.1633263812782739886.davem@davemloft.net>
To: Zubair.Kakakhel@imgtec.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, s.hauer@pengutronix.de,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH_V5] dm9000: Add regulator and reset support to dm9000
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421316746-38128-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1421316746-38128-1-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Jan 2015 11:08:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Date: Thu, 15 Jan 2015 10:12:26 +0000

> In boards, the dm9000 chip's power and reset can be controlled by gpio.
> 
> It makes sense to add them to the dm9000 driver and let dt be used to
> enable power and reset the phy.
> 
> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
> Signed-off-by: Paul Burton <paul.burton@imgtec.com>

Applied to net-next, thanks.
