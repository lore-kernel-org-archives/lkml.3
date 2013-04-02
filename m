Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368Ab3DBX0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:26:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50070 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3DBX0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:26:03 -0400
Date: Tue, 02 Apr 2013 19:26:01 -0400 (EDT)
Message-Id: <20130402.192601.800808445795589231.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/7] r8169: add a new chip for RTL8111G
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130402232008.GB16612@electric-eye.fr.zoreil.com>
References: <20130401222235.GB19335@electric-eye.fr.zoreil.com>
	<2808A1ABA9A5470C8CB9534309588984@realtek.com.tw>
	<20130402232008.GB16612@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 02 Apr 2013 16:26:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Wed, 3 Apr 2013 01:20:08 +0200

> hayeswang <hayeswang@realtek.com> :
>> Francois Romieu [mailto:romieu@fr.zoreil.com] 
> [...]
>> > There is close to zero added value for this stuff in the kernel.
>> > You may as well move it completely into the firmware.
>> 
>> Do you mean all of the phy settings ? I have checked these settings with
>> our hw engineers. These are not firmware. 
> 
> Undocumented configuration data which is subject to change over time ?
> 
> No one outside of Realtek can make any sense of this opaque pile of data.
> There is no point in me or anybody else rubber stamping it for inclusion.

Right, so either document all of these indirect registers being programmed
in the PHY or move it to firmware.
