Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab3ETUMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:12:21 -0400
Received: from mout.gmx.net ([212.227.17.22]:64708 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab3ETUMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:12:20 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18IvB9DaTEIGJdSgLeV5VPl7Gj6U8hY9yVE9skHb6
	VbLRmtiL3uHLxC
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH] net/can/mcp251x: Use module_spi_driver to register driver
Date: Mon, 20 May 2013 22:17:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1369079399-6031-1-git-send-email-peterhuewe@gmx.de> <519A7F3B.1000105@pengutronix.de>
In-Reply-To: <519A7F3B.1000105@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305202217.29983.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. Mai 2013, 21:53:31 schrieb Marc Kleine-Budde:
> On 05/20/2013 09:49 PM, Peter Huewe wrote:
> > Removing some boilerplate by using module_spi_driver instead of calling
> > register and unregister in the otherwise empty init/exit functions
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
> A similar patch [1] by Lars-Peter Clausen hit mainline in v3.10-rc1.
> 
> thanks, Marc
> 
> [1] 01b8807 can: mcp251x: Use module_spi_driver


Thanks for noticing!
I was unfortunately working on a stale tree - sorry for the noise.

Thanks,
Peter
