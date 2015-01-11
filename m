Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbbAKXyz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:54:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41431 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbAKXyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:54:52 -0500
Date: Sun, 11 Jan 2015 18:54:45 -0500 (EST)
Message-Id: <20150111.185445.1288456704842706068.davem@davemloft.net>
To: peter.griffin@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, kishon@ti.com,
        arnd@arndb.de, lee.jones@linaro.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Fix sti drivers whcih mix reg address spaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420643052-4506-1-git-send-email-peter.griffin@linaro.org>
References: <1420643052-4506-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Jan 2015 15:54:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>
Date: Wed,  7 Jan 2015 15:04:05 +0000

> A V2 of this old series incorporating Arnd and Lees Feedback form v1.
> 
> Following on from Arnds comments about the picophy driver here
> https://lkml.org/lkml/2014/11/13/161, this series fixes the
> remaining upstreamed drivers for STI, which are mixing address spaces
> in the reg property. We do this in a way similar to the keystone
> and bcm7445 platforms, by having sysconfig phandle/ offset pair 
> (where only one register is required). Or phandle / integer array
> where multiple offsets in the same bank are needed).
> 
> This series breaks DT compatability! But the platform support
> is WIP and only being used by the few developers who are upstreaming
> support for it. I've made each change to the driver / dt doc / dt
> file as a single atomic commit so the kernel will remain bisectable. 
> 
> This series then also enables the picophy driver, and adds back in
> the ehci/ohci dt nodes for stih410 which make use of the picophy.

Series applied to net-next, thanks.
