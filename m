Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaBLVEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:04:50 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46893 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753067AbaBLVEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:04:49 -0500
Date: Wed, 12 Feb 2014 22:04:46 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, b.brezillon@overkiz.com,
        gregory.clement@free-electrons.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/8] at91: dt: Add at91sam9261 dt SoC support
Message-ID: <20140212210446.GF11498@piout.net>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
 <1392199607-27452-4-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392199607-27452-4-git-send-email-jjhiblot@traphandler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, one more comment on that patch:

On 12/02/2014 at 11:06:42 +0100, Jean-Jacques Hiblot wrote :
> +			pinctrl@fffff400 {
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				compatible = "atmel,at91rm9200-pinctrl", "simple-bus";
> +				ranges = <0xfffff400 0xfffff400 0xa00>;
> +
I believe you got the range wrong, shouldn't it be:
				ranges = <0xfffff400 0xfffff400 0x600>;


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
