Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaIIUXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:23:33 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53305 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaIIUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:23:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bhelgaas@google.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 1/2] PCI: keystone: remove handle of PCI mode configuration
Date: Tue, 09 Sep 2014 22:22:54 +0200
Message-ID: <2873880.LROUF1qxur@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com>
References: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5QRtBipBf1EwIpmjfqIIlf1TZjY/pHvDom2FF5PaiRx
 uvYIjbhMIzP9wCAuTJ2sHbT00sn0Wt5W2h8kmXys1dkfsVW9x7
 cx/9d0JyUSGcWEq26rDvRbrPEQDlWvxh8jzBjk0o0mS90IQyct
 xRDoCwjhWt0PMTCWbiQna18inMeh+jXCWANiufC1w1YUXTN44K
 n8ReNLaIbnR211eRcVNj4LKpMR24i1Oo2vqoeoCU5sHdumEQ5P
 dbHOPfvR8fqGsb4EBMuiLcqxd0RPoYyB4DU412Sv9l4xv12jpP
 bxgEHF2KgCNlbNezvYrV6Owkwup31r8UzLcpJO6cm/Qcj69shV
 N5THevXiI2Ezz/GJ6C7w=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 16:17:14 Murali Karicheri wrote:
> Keystone PCI hardware supports both RC and EP modes and devcfg
> register has bits to boot strap the device to either of these modes.
> It seems proper to add this functionality to the boot loader rather
> than in the driver as device will be operating in either mode, not
> both any time. Currently the driver supports only RC mode and hence
> register configuration in the driver is not needed and driver can
> assume this is a RC hardware.
> 
> Also update the DT documentation accordingly.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 

Thanks for doing this,

Acked-by: Arnd Bergmann <arnd@arndb.de>
