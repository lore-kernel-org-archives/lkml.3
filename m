Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaKZVjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:39:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50985 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKZVjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:39:22 -0500
Date: Wed, 26 Nov 2014 16:39:20 -0500 (EST)
Message-Id: <20141126.163920.2254225978631403023.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-11-26
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141126194743.GA12284@tuxdriver.com>
References: <20141126194743.GA12284@tuxdriver.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Nov 2014 13:39:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 26 Nov 2014 14:47:43 -0500

> Please pull this little batch of fixes intended for the 3.18 stream...
> 
> For the iwlwifi one, Emmanuel says:
> 
> "Not all the firmware know how to handle the HOT_SPOT_CMD.
> Make sure that the firmware will know this command before
> sending it. This avoids a firmware crash."
> 
> Along with that, Larry sends a pair of rtlwifi fixes to address some
> discrepancies from moving drivers out of staging.  Larry says:
> 
> "These two patches are needed to fix a regression introduced when
> driver rtl8821ae was moved from staging to the regular wireless tree."
> 
> Please let me know if there are problems!

Pulled John, thanks a lot!
