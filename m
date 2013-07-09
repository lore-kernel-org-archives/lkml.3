Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3GIH4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:56:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3GIH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:56:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: srinivas.kandagatla@st.com
Subject: Re: [PATCH v1 0/4] ARM: STi fixes and ethernet support
Date: Tue, 9 Jul 2013 09:56:02 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Olof Johansson <olof@lixom.net>
References: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com> <201307090118.06715.arnd@arndb.de> <51DBB629.1050000@st.com>
In-Reply-To: <51DBB629.1050000@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307090956.03191.arnd@arndb.de>
X-Provags-ID: V02:K0:o9hJ8XVUOGPMnXG4PtuucbTWUXd1ShGpMllzPxPiXy7
 HYpcIeRGVF/I/qHqdQUq5NmYx1ZjHjg6YYMPhXEijB3P+xu17c
 mY9MsMtDj44yT9QilV0jicq183aJIZkNbbyIKM+J4KCTmIPkYt
 f8LFltgQpaLjO5CdiP5hCZbc01Zbd++qeagJ8wZXnyYQ9mq8vk
 vN6+r/nXTx70ivN8Toje3MYWiwzysA1LNcxpuga2BSomOoruBV
 9WG0y5VKPb1htarYfHioLUhS4WwtbpoBeu7eE8O+T7SZHaBs7N
 qPs6x9TJz8+FcUz1/FIptvNDM6nj5t6Sp5WLK8cQCu8EGQaycX
 djQxrZgNnmn9+OZiIefM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 July 2013, Srinivas KANDAGATLA wrote:
> stmmac (aka "dwmac" a synopsis IP) driver is integrated in to kernel
> sometime in 2.6 series I think :-), and Is used by more than 4 platforms
> in 3.10 kernel. The driver is more generic than it sounds.
> So adding properties/hooks specific to STiH41x SOCs in driver seemed to
> incorrect. Instead doing platform specific bits in the mach via
> callbacks was the only choice I had.

No, you should be using generic interfaces to do the things you need.

I believe what you are missing is an ethernet phy driver that is specific
to your SoC.

	Arnd
