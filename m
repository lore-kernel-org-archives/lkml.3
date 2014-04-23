Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbaDWS7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:59:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50822 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaDWS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:59:28 -0400
Date: Wed, 23 Apr 2014 14:59:26 -0400 (EDT)
Message-Id: <20140423.145926.998744821096383568.davem@davemloft.net>
To: hchaumette@adeneo-embedded.com
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] net/phy: micrel: fix bugged test on device tree
 loading for ksz9021
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398171664-32662-1-git-send-email-hchaumette@adeneo-embedded.com>
References: <1398171664-32662-1-git-send-email-hchaumette@adeneo-embedded.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Apr 2014 11:59:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hubert Chaumette <hchaumette@adeneo-embedded.com>
Date: Tue, 22 Apr 2014 15:01:04 +0200

> In ksz9021_load_values_from_of() val2 to val4 aren't tested against their
> initialization value.
> This causes the test to always succeed, and this value to be used as if it
> was loaded from the devicetree instead of being ignored, in case of a
> missing/invalid property in the ethernet OF device node.
> As a result, the value "0" is written to the relevant registers.
> 
> Change the conditions to test against the right initialization value.
> 
> Signed-off-by: Hubert Chaumette <hchaumette@adeneo-embedded.com>

Applied, thanks.
