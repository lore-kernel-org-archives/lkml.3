Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaAGPiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:38:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52125 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaAGPhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:37:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Meier <florian.meier@koalo.de>
Subject: Re: [PATCHv10] dmaengine: Add support for BCM2835
Date: Tue, 7 Jan 2014 16:37:02 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rpi-kernel" <linux-rpi-kernel@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "Lars-Peter Clausen" <lars@metafoo.de>
References: <52CB0180.1040605@koalo.de>
In-Reply-To: <52CB0180.1040605@koalo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401071637.03135.arnd@arndb.de>
X-Provags-ID: V02:K0:snm156ZV8FsGNTPzx1uTWyw4Scmzfh7Uvp3DAtGAd1s
 UqtLAJtAtGtwZ1TiArp6SjdcmoLHkGvEoibmwF4lvMdBtjCUYL
 R06nE+cZisxF1BTcTr9UrZlQukqkDjQ+4HvlAqU15KiPN/qxJd
 YgF7aCrHmQ0rBY9UZYcr1QQusKy1DvtRJG0iwft8dVaXg3d1VR
 s4vDY+Dmgj3xFfa1L3T16wE8T4E/k0OBhP19SdIHJ+7pPWDh7T
 bojHFxXk7mNsK5PWRHqWohr3OXUsmWABtygi27DgDVKFwDn2L9
 6S4+Jc/FGu1ZriYAa1rIfd0Z9EiQczOpyi8pf0bkF/39fsNYPf
 G7LbQtlp1KQJSngUgRE4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 January 2014, Florian Meier wrote:
> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> Currently it only supports cyclic DMA.
> 
> Signed-off-by: Florian Meier <florian.meier@koalo.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
