Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab3CUP6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:58:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43668 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab3CUP57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:57:59 -0400
Date: Thu, 21 Mar 2013 11:57:57 -0400 (EDT)
Message-Id: <20130321.115757.176260167306171131.davem@davemloft.net>
To: mugunthanvnm@ti.com
Cc: LW@KARO-electronics.de, richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX PATCH] net: ethernet: cpsw: fix erroneous condition in
 error check
From: David Miller <davem@davemloft.net>
In-Reply-To: <514AFDD5.9020608@ti.com>
References: <1363868411-25318-1-git-send-email-LW@KARO-electronics.de>
	<514AFDD5.9020608@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 21 Mar 2013 08:58:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mugunthan V N <mugunthanvnm@ti.com>
Date: Thu, 21 Mar 2013 18:02:21 +0530

> On 3/21/2013 5:50 PM, Lothar Waﬂmann wrote:
>> The error check in cpsw_probe_dt() has an '&&' where an '||' is
>> meant to be. This causes a NULL pointer dereference when incomplet DT
>> data is passed to the driver ('phy_id' property for cpsw_emac1
>> missing).
>>
>>
>> Signed-off-by: Lothar Waﬂmann<LW@KARO-electronics.de>
> Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Applied, thanks.
