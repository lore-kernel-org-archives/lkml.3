Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3COMJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:09:07 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54024 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab3COMJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:09:04 -0400
Date: Fri, 15 Mar 2013 09:08:58 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        hverkuil@xs4all.nl, elezegarcia@gmail.com
Subject: Re: [RFC V1 0/8] Add a driver for somagic smi2021
Message-ID: <20130315120856.GA2989@localhost>
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 03:06:56PM +0100, Jon Arne Jørgensen wrote:
> This patch-set will add a driver for the Somagic SMI2021 chip.
> 
> This chip is found inside different usb video-capture devices.
> Most of them are branded as EasyCap, but there also seems to be
> some other brands selling devices with this chip.
> 
> This driver is split into two modules, where one is called smi2021-bootloader,
> and the other is just called smi2021.
> 
> The bootloader is responsible for the upload of a firmware that is needed by some
> versions of the devices.
> 
> All Somagic devices that need firmware seems to identify themselves
> with the usb product id 0x0007. There is no way for the kernel to know
> what firmware to upload to the device without user interaction.
> 
> If there is only one firmware present on the computer, the kernel
> will upload that firmware to any device that identifies as 0x0007.
> If there are multiple Somagic firmwares present, the user will have to pass
> a module parameter to the smi2021-bootloader module to tell what firmware to use.
> 

Nice job!

I have some minor comments on each patch, but also I don't agree
with the patch splitting: what's the point in splitting and sending
one patch per file?

It doesn't make it any easier to review, so why don't you just
send one patch: "Introduce smi2021 driver"?

The rule is one patch per change, and I believe this whole patchset
is just one change: adding a new driver.

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
