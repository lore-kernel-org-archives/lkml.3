Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3JHPvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:51:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60794 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3JHPvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:51:11 -0400
Message-ID: <525429EB.90304@baylibre.com>
Date: Tue, 08 Oct 2013 17:51:07 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/3] AM33XX crypto DTS patches
References: <1380999877-20884-1-git-send-email-joelf@ti.com>
In-Reply-To: <1380999877-20884-1-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

n 05/10/2013 21:04, Joel Fernandes wrote:
> These patches are some minor fixups and changes to commit messages to the
> AM33XX crypto (aes, sham) patches with reference to the comments at:
> http://comments.gmane.org/gmane.linux.drivers.devicetree/45961
>
> Joel Fernandes (1):
>    ARM: dts: AM33XX: Fix AES interrupt number
>
> Mark A. Greer (2):
>    ARM: dts: AM33XX: Add SHAM data and documentation
>    ARM: dts: AM33XX: Add AES data and documentation
>
>   .../devicetree/bindings/crypto/omap-aes.txt        | 31 ++++++++++++++++++++++
>   .../devicetree/bindings/crypto/omap-sham.txt       | 28 +++++++++++++++++++
>   arch/arm/boot/dts/am335x-bone.dts                  |  8 ++++++
>   arch/arm/boot/dts/am335x-evm.dts                   |  8 ++++++
>   arch/arm/boot/dts/am335x-evmsk.dts                 |  8 ++++++
>   arch/arm/boot/dts/am33xx.dtsi                      | 19 +++++++++++++
>   6 files changed, 102 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt
>   create mode 100644 Documentation/devicetree/bindings/crypto/omap-sham.txt
>

I've just applied this series and the remaining ones from the previous 
version.

Thanks,
Benoit

