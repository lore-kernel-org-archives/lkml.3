Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbaCTLnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:43:14 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:35549 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbaCTLnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:43:10 -0400
Message-ID: <532AD44A.90409@monstr.eu>
Date: Thu, 20 Mar 2014 12:43:06 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 0/9] tty: xuartps: Rebranding + DT documentation
References: <1394650983-24780-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1394650983-24780-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 03/12/2014 08:02 PM, Soren Brinkmann wrote:
> Here is a fixed and extended v3. I picked up Michal's patches and
> incorporated them into the series. Those are the first two patches.
> The 'rebranding' patch is correspondingly extended to convert the new
> code as well.
> 
> The erroneously changed compatibility string has been reverted back to
> what it should be.
> 
> 	Sören
> 
> Michal Simek (2):
>   tty: xuartps: Fix kernel-doc errors in the driver
>   tty: xuartps: Initialize ports according to aliases
> 
> Soren Brinkmann (7):
>   tty: xuartps: Clean up
>   tty: xuartps: Print warning in clock notifier
>   tty: xuartps: Refactor read-modify-writes
>   tty: xuartps: Don't write IRQ disable register to enable interrupts
>   tty: xuartps: Rebrand driver as Cadence UART
>   tty: cadence: Document DT binding
>   ARM: zynq: DT: Migrate UART to Cadence binding

I have done boot test and console is still there
that's why
Tested-by: Michal Simek <michal.simek@xilinx.com>

I think that 1/9 - 8/9 should go through your tree
and 9/9 should go through arm-soc because there could
be some conflicts in dtsi.

Can you please apply that patches and I will take the rest
through arm-soc tree?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform

