Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaLDJod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:44:33 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:40724 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751785AbaLDJob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:44:31 -0500
Message-ID: <54802CDD.6080000@arm.com>
Date: Thu, 04 Dec 2014 09:43:57 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>
Subject: Re: [PATCH 4/5] ASoC: dwc: Add devicetree support for Designware
 I2S
References: <547F3CAC.9050105@arm.com> <2041200.ZjakFFAZAU@wuerfel>
In-Reply-To: <2041200.ZjakFFAZAU@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 20:13, Arnd Bergmann wrote:
> On Wednesday 03 December 2014 16:39:08 Andrew Jackson wrote:
>> Convert to driver to use either platform_data or device-tree for configuration
>> of the device.  When using device-tree, the I2S block's configuration is read
>> from the relevant registers: this reduces the amount of information required in
>> the device tree.
>>
>> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> 
> I don't think we even have to worry about the platform_data case here:
> the only platform using this hardware in Linux is arm/mach-spear, and
> it defines a device node with a binding that is similar to the one you
> document here but that is not implemented in the driver.
> 
> So, I think for all practical purposes we can assume that nobody cares
> if you make incompatible changes as long as you don't introduce build
> regression.
> 
> Also, please adapt the 	arch/arm/boot/dts/spear13*.dts{,i} files
> as good as you can. They are broken in other ways too that you don't
> have to fix, just make them conform to the binding you add.
> 

Will do.  Although I had noticed those DT entries, I couldn't find anything in support of them.  I wasn't sure whether someone else was waiting in the wings (so as to speak) with a DT enabled Designware I2S driver. 

> 	Arnd
> 
> 

