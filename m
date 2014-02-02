Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaBBA50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:57:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51152 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaBBA5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:57:24 -0500
Date: Sat, 01 Feb 2014 16:57:23 -0800 (PST)
Message-Id: <20140201.165723.159807875655406849.davem@davemloft.net>
To: jcmvbkbc@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        f.fainelli@gmail.com, marc@cadence.com
Subject: Re: [PATCH v2 0/4] OpenCores 10/100 MAC ethtool operations
From: David Miller <davem@davemloft.net>
In-Reply-To: <1391146867-30508-1-git-send-email-jcmvbkbc@gmail.com>
References: <1391146867-30508-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>
Date: Fri, 31 Jan 2014 09:41:03 +0400

> Hello David, Ben, Florian and everybody,
> 
> this series implements ethtool callbacks for the ethoc driver as was
> requested by Florian.
> 
> Changes v1->v2:
> - fix {get,set}_settings return code in case there's no PHY;
> - fix set_ringparam: check ring sizes, change ring sizes on the fly.

Series applied, thanks.
