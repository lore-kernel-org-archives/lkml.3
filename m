Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3AQUrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:47:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53378 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3AQUrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:47:49 -0500
Date: Thu, 17 Jan 2013 15:47:47 -0500 (EST)
Message-Id: <20130117.154747.1471793083875584682.davem@davemloft.net>
To: stef.van.os@prodrive.nl
Cc: chohnstaedt@innominate.com, srinivas.kandagatla@st.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] phy/marvell: remove fiber/copper autoselect on
 88e1111
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358436978-7504-1-git-send-email-stef.van.os@prodrive.nl>
References: <1358436978-7504-1-git-send-email-stef.van.os@prodrive.nl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stef van Os <stef.van.os@prodrive.nl>
Date: Thu, 17 Jan 2013 16:36:18 +0100

> Remove the code that always enables copper/fiber autoselect,
> ignoring the DIS_FC strapping pin. The default value for this
> register is autoselect on anyway, and if you explicitly disable
> autoselect via strapping you probably really don't want
> autoselect.
> 
> Signed-off-by: Stef van Os <stef.van.os@prodrive.nl>

Applied, thanks.
