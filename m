Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab3BFSTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:19:19 -0500
Received: from smtp1.goneo.de ([212.90.139.80]:64038 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744Ab3BFSTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:19:16 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.744
From: Lars Poeschel <poeschel@lemonage.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH RFC] misc/at24: distinguish between eeprom and fram chips
Date: Wed, 6 Feb 2013 19:19:18 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
References: <201212041758.38600.poeschel@lemonage.de> <201212051043.07460.poeschel@lemonage.de> <20121205164153.GA5011@pengutronix.de>
In-Reply-To: <20121205164153.GA5011@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302061919.18501.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 December 2012 at 17:41:53, Wolfram Sang wrote:

> > > The method of accessing EEPROMs is used by way more chips than FRAMs.
> > > So, I'd prefer to have the text updated more generic like "EEPROMs and
> > > similar devices like RAMs, ROMs, etc...". Describing setting .flags in
> > > Kconfig is overkill.
> > 
> > A patch updating Kconfig is below.
> 
> Looks good from a glimpse, will apply it later.

Hello Wolfram,

what happend to this one ? It was a patch updating Kconfig help for at24.

https://patchwork.kernel.org/patch/1840591/

Regards,
Lars
