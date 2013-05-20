Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab3ETUEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:04:08 -0400
Received: from mout.gmx.net ([212.227.17.21]:58054 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab3ETUEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:04:06 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19mpWh4IwxmJSiFvWVze8J2Cua4PZh2QMVO98PkIJ
	nxFoYMWB3DacWi
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/ethernet/micrel/ks8851.c: Use module_spi_driver to register driver
Date: Mon, 20 May 2013 22:09:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: Bill Pemberton <wfp5p@virginia.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1369079776-6214-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1369079776-6214-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305202209.16076.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. Mai 2013, 21:56:16 schrieb Peter Huewe:
> Removing some boilerplate by using module_spi_driver instead of calling
> register and unregister in the otherwise empty init/exit functions
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>


Sorry for the noise 
 already exists in 3.10-rc1 by Lars-Peter Clausen
	0582ce92  net: ks8851: Use module_spi_driver	Lars-Peter Clausen

I was working on an stale tree - sorry.
Please ignore this patch.

Peter
