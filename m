Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbaKSVyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:54:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39188 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149AbaKSVyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:54:41 -0500
Date: Wed, 19 Nov 2014 16:54:39 -0500 (EST)
Message-Id: <20141119.165439.1170554636889327742.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH 1/1] mISDN: Deletion of unnecessary checks before the
 function call "vfree"
From: David Miller <davem@davemloft.net>
In-Reply-To: <546CF5A6.3030305@users.sourceforge.net>
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<546CF5A6.3030305@users.sourceforge.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 13:54:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 20:55:18 +0100

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 19 Nov 2014 20:48:26 +0100
> 
> The vfree() function performs also input parameter validation. Thus the test
> around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied, thanks.
