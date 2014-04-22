Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbaDVQ3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:29:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50357 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756944AbaDVQ25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:28:57 -0400
Date: Tue, 22 Apr 2014 18:28:44 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, tj@kernel.org, zmxu@marvell.com,
        jszhang@marvell.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/6] ARM: berlin: add the AHCI node for the BG2Q
Message-ID: <20140422182844.3f2eb558@skate>
In-Reply-To: <1398181105-19714-4-git-send-email-antoine.tenart@free-electrons.com>
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
	<1398181105-19714-4-git-send-email-antoine.tenart@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Antoine Ténart,

On Tue, 22 Apr 2014 17:38:22 +0200, Antoine Ténart wrote:

> +		ahci: sata@e90000 {
> +			compatible = "marvell,berlin-ahci";
> +			reg = <0xe90000 0x10000>;
> +			interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
> +			status = "disable";

Should be:

			status = "disabled";

And ditto for patches 5 and 6.

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
