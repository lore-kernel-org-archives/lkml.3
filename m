Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaAQREu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:04:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaAQREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:04:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 7/7] ARM: brcmstb: dts: add a reference DTS for Broadcom 7445
Date: Fri, 17 Jan 2014 18:04:29 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Marc C <marc.ceeeee@gmail.com>, Michal Simek <michal.simek@xilinx.com>,
        David Brown <davidb@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com> <201401161219.01038.arnd@arndb.de> <20140116134732.GB17314@sirena.org.uk>
In-Reply-To: <20140116134732.GB17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401171804.30572.arnd@arndb.de>
X-Provags-ID: V02:K0:vJ1ckRfzdn4JkladEmiqiWtFfMLmxXVRMOgoGARKqW1
 AZMmkWIFl3Qx/8YHiLlW0CDphdbAeb4fexEf3L+GTcSGP/80Kz
 XzzaafCYJpB96S1YX84uzonhug4b/+TfZD0DUTU3DfoUr0Y9hR
 XMgBlrTfbCUwgEMGcQvzBHSPfUM5kkWhXdBwz5GKlDKbvsDguq
 3Anddn5OClkJngk+D2iKrsCjssrnHD55sIiC3hgdrAppPC7g+y
 9z4Ee+3iKDbxkNfq68BsNriEy2MLpt9yPABMFe23uba/V2iVRo
 nxPkpkT3Okaeb+XDCgVDCE9bHc0wOkWEGjFIeyU8KNTRR803M2
 SetHxFahjLHgMT0iJ+Kg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 January 2014, Mark Brown wrote:
> On Thu, Jan 16, 2014 at 12:19:00PM +0100, Arnd Bergmann wrote:
> 
> > 1. Other platforms also require the syscon driver to be active before
> > the regular device driver probing starts. Michal Simek has the same
> > issue in the zynq clock driver that you have for SMP initialization.
> > We have talked about this with Mark Brown already, and I think we will
> > find a solution for this in the end, but it's not as straightforward
> > as I first hoped. We can probably use help in this area.
> 
> I thought the solution with deferring registration of the resource for
> dev_get_regmap() until a proper device materialised seemed simple and
> enough, did you folks run into any problems with that?  I had assumed a
> patch was likely to materialise so wasn't worrying about it myself.

I'm still hoping that Michal will do that patch.

	Arnd
