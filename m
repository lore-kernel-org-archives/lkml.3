Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaB0TRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:17:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:50200 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0TRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:17:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
Subject: Re: [PATCH v8.1 1/6] dt-bindings: sram: describe option to reserve parts of the memory
Date: Thu, 27 Feb 2014 20:16:23 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        arm@kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Sachin Kamat <sachin.kamat@linaro.org>
References: <21117503.1c6iOkvYSr@phil> <201402251419.31151.arnd@arndb.de> <2574291.evU61mFTUd@phil>
In-Reply-To: <2574291.evU61mFTUd@phil>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201402272016.23521.arnd@arndb.de>
X-Provags-ID: V02:K0:quarLeCoas2pFnQzo/iiCJwM43MEoOjoaI/t+Po/7WE
 rZJDvQipeY/7AojI9gEYuvjy3PVeVquSbYCCJ/qFYxwoDDnmKT
 3evf/S2e3nSrZxFUnIy8Yw2JxjOX4Urf5+3uyHBbNCwPcvGRh8
 p5mfl/vbu9hvn/VBNk7sI+gOMQSCgoHw9OZV9D7GSdqxWMdmsz
 zr8sDlE/DufFI+JiwJvk8uHDQTCVXE1wYUXMbRvzXtgwcKOQ6L
 pBngOImja1aqs4VLc28L+GtUtR9w4KXQZP69MOxfcPi4VfDvI4
 ek/HY/14mTrnDSp6Z+4ZFizWnYpbYwDWm+G5N01Fo7z40jSDYO
 a8+olp265SXN7dwCe1/M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Heiko Stübner wrote:
> Some SoCs need parts of their sram for special purposes. So while being part
> of the peripheral, it should not be part of the genpool controlling the sram.
> 
> Therefore add the option to define reserved regions as subnodes of the
> sram-node similar to defining reserved global memory regions.
> 
> Originally
> Suggested-by: Rob Herring <robherring2@gmail.com>
> 
> Using subnodes for reserved regions
> Suggested-by: Grant Likely <grant.likely@linaro.org>
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
