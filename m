Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbaDWT07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:26:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51103 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaDWT0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:26:55 -0400
Date: Wed, 23 Apr 2014 15:26:53 -0400 (EDT)
Message-Id: <20140423.152653.2008980151348280912.davem@davemloft.net>
To: alchark@gmail.com
Cc: rl@hellgate.ch, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@prisktech.co.nz,
        robh+dt@kernel.org, ben@decadent.org.uk
Subject: Re: [PATCH v2 0/3] net: via-rhine: add support for on-chip Rhine
 controllers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398180489-20230-1-git-send-email-alchark@gmail.com>
References: <1390823503-24087-1-git-send-email-alchark@gmail.com>
	<1398180489-20230-1-git-send-email-alchark@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Apr 2014 12:26:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Charkov <alchark@gmail.com>
Date: Tue, 22 Apr 2014 19:28:06 +0400

> This series introduces platform bus (OpenFirmware) binding for 
> via-rhine, as used in various ARM-based Systems-on-Chip by 
> VIA/WonderMedia.
> 
> This has been tested in OF configuration by myself on a WM8950-based VIA 
> APC Rock development board and on a WM8850-based netbook, and in PCI
> configuration by Roger.
> 
> Please note that the initial version of these patches was signed off by
> Roger, but some time has passed since then, so I'm not including his
> sign-off until explicit notice.
> 
> David, could you please take these to net-next if appropriate?

Series applied to net-next, thanks Alexey.
