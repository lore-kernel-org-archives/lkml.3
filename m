Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3JAP1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:27:55 -0400
Received: from mail-de.keymile.com ([195.8.104.250]:60412 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3JAP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:27:46 -0400
Message-ID: <524AE9E3.4080701@keymile.com>
Date: Tue, 01 Oct 2013 17:27:31 +0200
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130917 Thunderbird/17.0.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [patch 0/8] genirq: Support for irq domains in generic irq chip
 - V2
References: <20130506142348.321859745@linutronix.de>
In-Reply-To: <20130506142348.321859745@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Sebastian,

I see these changes made it to 3.11.
AFAICT though, 3.10.9 still has the original bug (the one that got me to 
write the patch for handling separate mask registers) and I am bit 
confused as to how to integrate that back into 3.10 (or any previous 
affected kernels, as they deserve a fix as well!).

The way I understand it, any mainstream patch would be based on this 
work, which is not available on previous kernels. And I guess 
backporting the whole thing would be overkill.
So I believe the only way to fix it on older kernels would be to write 
one (or more) minimal version-specific patch series.
But then I wonder: would that be acceptable material for linux-stable?

Please correct me if I'm totally wrong here. I'm willing to help & test 
but I need directions.

Thanks,
Gerlando

On 05/06/2013 04:30 PM, Thomas Gleixner wrote:
> Changes vs. V1:
>
> 	- Fixed the generic chip pointer thinko (Sebastian Hesselbarth)
>
> 	- Proper support for mask cache
>
> 	- Read mask hardware only for the first map of an generic chip
>            instance
>
> 	- sun4i prefix irq functions proper
>
> Thanks,
>
> 	tglx
>
>

