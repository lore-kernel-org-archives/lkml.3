Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaJJSsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:48:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55957 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbaJJSsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:48:43 -0400
Date: Fri, 10 Oct 2014 14:48:41 -0400 (EDT)
Message-Id: <20141010.144841.1103657696761242978.davem@davemloft.net>
To: vbridger@opensource.altera.com
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vbridger@altera.com
Subject: Re: [PATCH net] stmmac: correct mc_filter local variable in
 set_filter and set_mac_addr call
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412867436-22153-1-git-send-email-vbridger@opensource.altera.com>
References: <1412867436-22153-1-git-send-email-vbridger@opensource.altera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Oct 2014 11:48:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vince Bridgers <vbridger@opensource.altera.com>
Date: Thu, 9 Oct 2014 10:10:36 -0500

> Testing revealed that the local variable mc_filter was dimensioned
> incorrectly for all possible configurations and get_mac_addr should
> have been set_mac_addr (a typo). Make sure mc_filter is dimensioned
> to 8 32-bit unsigned longs - the largest size of the Synopsys
> multicast filter register set.
> 
> Signed-off-by: Vince Bridgers <vbridger@opensource.altera.com>

Applied, thanks vince.
