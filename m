Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035Ab3FSSrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:47:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794Ab3FSSrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:47:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH RFC 0/2] Extend multi_v7_defconfig
Date: Wed, 19 Jun 2013 20:46:40 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306192046.41005.arnd@arndb.de>
X-Provags-ID: V02:K0:9Cl9mu0WHx+sTv0/4yutPpTpHKjwP/xIiIFmQRyAmgI
 fcex4oyBBkM5NWsn55i5i0Y5L8qc7tKtTfxft1W7cTm4gpG9yz
 EC4LDT5g+J660rOdF1tB0VIw/TMCfHfI2cjcd8OqRA3XGhMSsX
 DBCDl2k81sxDy+80p3t0s5R1nGcPpgdgd8XJOhC5VxuwNtHGnk
 wq4o5OwloKqo+mgxzIRUdXKGRTpsiCCKi1sXtVTm8Sl6tEcbq6
 f9bdjAoqk+ANLSrbrnHwgUAQQksK9UdwokT29eEmkMDRp5R9vR
 SK9M3j181F7+slGSBKlrX9xHKPp0t5yBi/VwDcQ92xVOkHhXQl
 6QWllP6sTTXQql7WHXyQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Soren Brinkmann wrote:
> I don't know how much a defconfig is supposed to provide, hence as RFC.
> This patches are needed for booting Zynq into a minimum ramfs based
> system with a serial console.

In my opinion we should provide enable all the platform specific drivers
in the defconfigs, as well as everything needed to boot the system,
to get proper compile coverage as well as the ability to test changes
easily. Your patches look good. Michal, would you apply them and
send another pull request or should I just take them directly?

	Arnd
