Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3C0Czn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 22:55:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52860 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3C0Czm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 22:55:42 -0400
Message-ID: <51525FAC.2010106@wwwdotorg.org>
Date: Tue, 26 Mar 2013 20:55:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH v2] bcm2835: Add Broadcom BCM2835 RNG to the device tree
References: <1363956930-5717-1-git-send-email-lkundrak@v3.sk> <1364135511-26970-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1364135511-26970-1-git-send-email-lkundrak@v3.sk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2013 08:31 AM, Lubomir Rintel wrote:
> This adds a device tree binding for random number generator present on Broadcom
> BCM2835 SoC, used in Raspberry Pi and Roku 2 devices.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: linux-rpi-kernel@lists.infradead.org
> ---
> Changes for v2:
>     - Split out from the driver changeset
>     - Added documentation
> 
>  .../devicetree/bindings/rng/brcm,bcm2835.txt       |   13 +++++++++++++
>  arch/arm/boot/dts/bcm2835.dtsi                     |    5 +++++
>  2 files changed, 18 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm2835.txt

I think it's more typical to include the binding document with the
driver patch, so that one patch both defines and implements the binding.
A separate patch then instantiates the binding (i.e. adds entries to *.dts).

Patches that create new DT bindings should be posted to
devicetree-discuss@lists.ozlabs.org, although this one is so simple that
I doubt it will generate any discussion.

Patches that affect ARM files should be posted to
linux-arm-kernel@lists.infradead.org. I typically post there instead of
the main linux-kernel@ mailing list.

I assume you're going to repost this anyway once you've addressed the
authorship issue, so you'll have an opportunity to correct all this.

The actual content of this patch seems fine.
