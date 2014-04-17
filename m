Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161434AbaDQNjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:39:01 -0400
Received: from mail.data-modul.de ([212.184.205.171]:56944 "HELO
	mailgw1.data-modul.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751516AbaDQNi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:38:59 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2014 09:38:58 EDT
From: Silvio Fricke <silvio.fricke@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
Subject: Re: [PATCH 0/6] mfd/gpio: cleanup of STMPE driver
Date: Thu, 17 Apr 2014 15:28:05 +0200
Message-Id: <cover.1397741024.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140417061136.GD11602@dragon>
References: <20140417061136.GD11602@dragon>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tested this patches with my data-modul imx6q board.
So the patches get a:

Tested-by: Silvio Fricke <silvio.fricke@gmail.com>


Shawn, can you add this patch to your tree if you pull Linus patches?

Thx and Cheers,
Silvio

Silvio Fricke (1):
  ARM: dts: imx6: edmqmx6: add vcc and vio power supplies to stmpe

 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts | 4 ++++
 1 file changed, 4 insertions(+)

-- 
1.9.1

