Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3ETUKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:10:52 -0400
Received: from mout.gmx.net ([212.227.15.19]:56242 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab3ETUKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:10:51 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/PKGAAMVPP7JYtEZ/VtG2MvztTDVjBXaY38iDddH
	5B0CN+CeFDPbmk
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
Subject: Re: [PATCH] net/ieee802154/mrf24j40: Use module_spi_driver to register driver
Date: Mon, 20 May 2013 22:16:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1369079686-6160-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1369079686-6160-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305202216.02400.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. Mai 2013, 21:54:46 schrieb Peter Huewe:
> Removing some boilerplate by using module_spi_driver instead of calling
> register and unregister in the otherwise empty init/exit functions
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Sorry for the noise 
 already exists in 3.10-rc1
3d4a131 mrf24j40: use module_spi_driver to simplify the code

I was working on an stale tree - sorry.
Please ignore this patch.

Peter
