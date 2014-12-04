Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaLDJ4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:56:38 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:51796 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaLDJ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:56:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>
Subject: Re: [PATCH 4/5] ASoC: dwc: Add devicetree support for Designware I2S
Date: Thu, 04 Dec 2014 10:55:55 +0100
Message-ID: <2240364.fL8B0EDbFB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141203201905.GO7712@sirena.org.uk>
References: <547F3CAC.9050105@arm.com> <2041200.ZjakFFAZAU@wuerfel> <20141203201905.GO7712@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:A3zr6hu6Srl2XuuXaki8jx809mnV5EV/LwBgE8Ul3z0qrcyfCC9
 qguLz/gBb0jdWVNwDIoSYXRfBR1JRdhHWZuMUYCP+2bifJRdUInAis+fKXKvxfVImOaM0pK
 cPQdagQKO5Kpat8SvfjjNtj4mctLJiwnwHZwqGaVEsyUrc7PjEpUbUsTq3QvUAAWQt6Uesh
 cqNLThg+rZt9K9TMOiM/w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 20:19:05 Mark Brown wrote:
> On Wed, Dec 03, 2014 at 09:13:18PM +0100, Arnd Bergmann wrote:
> 
> > I don't think we even have to worry about the platform_data case here:
> > the only platform using this hardware in Linux is arm/mach-spear, and
> > it defines a device node with a binding that is similar to the one you
> > document here but that is not implemented in the driver.
> 
> Not all the world uses DT, this is a DesignWare IP so it's likely to get
> deployed widely - potentially on PCI cards and things like that.

It's not really new though, and we are only seeing the second user.
Maybe this one just isn't as common as a lot of the other designware IP?



	Arnd
