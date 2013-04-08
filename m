Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935452Ab3DHTP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:15:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761020Ab3DHTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:15:25 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Arnd Bergmann" <arnd@arndb.de>, "Daniel Tang" <dt.tangr@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        "Lionel Debroux" <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org,
        "Linus Walleij" <linus.walleij@linaro.org>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com>
 <4B3FD561-84FC-40CD-B747-13851692D673@gmail.com>
 <521DFDFC-7E9E-47EA-ACDA-C91BBDC8454E@gmail.com>
 <201304072323.42173.arnd@arndb.de>
 <896CB251-17FC-4327-BA4E-A8FD9ED1BEC7@gmail.com>
Date: Mon, 08 Apr 2013 21:16:27 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Fabian Vogt" <fabian@ritter-vogt.de>
Message-ID: <op.wu8k5pwqu7prd4@fabians-laptop.fritz.box>
In-Reply-To: <896CB251-17FC-4327-BA4E-A8FD9ED1BEC7@gmail.com>
User-Agent: Opera Mail/12.14 (Linux)
X-Provags-ID: V02:K0:fMaQu+Fl1cTV412VkV/vqomXN586MvyVts7AjnTykrA
 xdT3SgKC8FiFNg9fXGiiyfPQPAqr6kznuOuCk+8O5w9B0ty250
 zACChdubXYAdzuPEVfF2lz1BsPQVPTH2jd829KPDCGFnYQZI/r
 g8Wr/ZMH6ts9lM69Zj7XEPRk3YWFntx0f12b4epLmFtQcevlj8
 ACSV+/Bgf6N7+Nx7H8PyGXxD8IEjarArnhg1HCKGlGU40ZEBVL
 IACOccyXtVYoaD5ghoaup/yygbK9mB1moZU2eKkO4zhVURO2dL
 aLDVr9sWK2hNApHGqM1x5bFrDtVhyH6YeUsQnv4tgB/93HJBll
 702bRfnzrErkl0TPXf+SoNh5UQzrork1Jd6sAEpdfL5AO3PbAx
 ukVo+dWA3yENw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest kernel it seems to get stuck at
console_lock() in register_framebuffer (drivers/video/fbmem.c:1655)
if the LCD-controller is enabled. (Early printk and serial console works  
fine)
CONFIG_NO_HZ is not activated, it works completely.
Could this be a kernel bug or is this an issue with our timer  
configuration?
