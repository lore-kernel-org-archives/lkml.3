Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbaJIQvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:51:37 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39177 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaJIQv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:51:28 -0400
Date: Thu, 9 Oct 2014 09:51:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, netdev@vger.kernel.org
Subject: Upstream build failure due to commit d43a396af0 ('net: fs_enet: Add
 NAPI TX')
Message-ID: <20141009165122.GA1964@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see the following build failure in upstream Linux.

drivers/net/ethernet/freescale/fs_enet/mac-scc.c:119:32: error: 'SCCE_ENET_TXF' undeclared

This is not surprising as SCCE_ENET_TXF is not defined anywhere in the kernel.
linux-next fails to build with the same error.

Affected builds are
	powerpc:mpc85xx_defconfig
	powerpc:mpc85xx_smp_defconfig
	powerpc:tqm8xx_defconfig

Can you please have a look ?

Thanks,
Guenter
