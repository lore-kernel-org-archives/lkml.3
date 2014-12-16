Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbaLPQBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:01:44 -0500
Received: from down.free-electrons.com ([37.187.137.238]:35644 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751035AbaLPQBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:01:43 -0500
Date: Tue, 16 Dec 2014 17:01:38 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Evgeni Dobrev <evgeni@studio-punkt.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: dts: kirkwood: enable phy driver for SATA
 controller on 88f6192
Message-ID: <20141216170138.14dcabc1@free-electrons.com>
In-Reply-To: <20141215203724.GA22936@anne>
References: <20141215203724.GA22936@anne>
Organization: Free Electrons
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Evgeni Dobrev,

On Mon, 15 Dec 2014 21:37:24 +0100, Evgeni Dobrev wrote:
> This patch enables the phy drivers for the SATA controller on Marvell's 88f6192. Without them it is not possible to use SATA drives attached to this processor.

Commit log text should be wrapped to some reasonable length.


>  			interrupts = <21>;
>  			clocks = <&gate_clk 14>, <&gate_clk 15>;
>  			clock-names = "0", "1";
> +                        phys = <&sata_phy0>, <&sata_phy1>;
> +                        phy-names = "port0", "port1";

You should use tabs and not spaces for indentation in Device Tree files.

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
