Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaBMASv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:18:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34411 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBMASu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:18:50 -0500
Date: Wed, 12 Feb 2014 19:18:46 -0500 (EST)
Message-Id: <20140212.191846.1464564509609498703.davem@davemloft.net>
To: michal.simek@xilinx.com
Cc: netdev@vger.kernel.org, sthokal@xilinx.com, devicetree@vger.kernel.org,
        monstr@monstr.eu, John.Linn@xilinx.com, anirudh@xilinx.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/14] Xilinx axi ethernet patches
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1392220536.git.michal.simek@xilinx.com>
References: <cover.1392220536.git.michal.simek@xilinx.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Feb 2014 16:18:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>
Date: Wed, 12 Feb 2014 16:55:34 +0100

> I have exctracted patches which I have in our
> xilinx git tree which are missing in the mainline.
> 
> The first two patches fix compilation error and
> warnings. Then 5 feature patches
> and the rest is OF cleanup and with kernel-doc
> and checkpatch problems.

You should not combine bug fix and feature patches.

Rather, you should submit bug fixes against the 'net' tree.  Then when
those bug fixes get applied and propagate to the 'net-next' tree you
can submit the feature patches and cleanups against the 'net-next'
tree.
