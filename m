Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaAPXY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:24:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54818 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaAPXYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:24:24 -0500
Date: Thu, 16 Jan 2014 15:24:23 -0800 (PST)
Message-Id: <20140116.152423.417924760541282210.davem@davemloft.net>
To: srinivas.kandagatla@st.com
Cc: netdev@vger.kernel.org, peppe.cavallaro@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] net: stmmac PM related fixes.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389869321-27411-1-git-send-email-srinivas.kandagatla@st.com>
References: <1384774256-10039-1-git-send-email-srinivas.kandagatla@st.com>
	<1389869321-27411-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <srinivas.kandagatla@st.com>
Date: Thu, 16 Jan 2014 10:48:41 +0000

> During PM_SUSPEND_FREEZE testing, I have noticed that PM support in STMMAC is
> partly broken. I had to re-arrange the code to do PM correctly. There were lot
> of things I did not like personally and some bits did not work in the first
> place. I thought this is the nice opportunity to clean the mess up.

Series applied to net-next, thanks.
