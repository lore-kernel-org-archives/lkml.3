Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaBLFFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:05:10 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46753 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBLFFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:05:08 -0500
Message-ID: <52FB0102.3080108@wwwdotorg.org>
Date: Tue, 11 Feb 2014 22:05:06 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Florian Meier <florian.meier@koalo.de>
CC: linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] BCM2835: Add dmaengine driver to device tree
References: <52D3C9EF.1030901@koalo.de>
In-Reply-To: <52D3C9EF.1030901@koalo.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 04:11 AM, Florian Meier wrote:
> This adds the definitions for the BCM2835 dmaengine driver
> to the device tree. The dma-channel-mask is currently
> fixed. Later it should be set via the firmware.

I've applied patch 1, and the part of patch 2 which touches bcm2835.dtsi
to bcm2835's for-3.15/dt branch, with minor fixes.
