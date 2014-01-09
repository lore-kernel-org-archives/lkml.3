Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaAIKBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:01:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaAIKBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:01:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: boris brezillon <b.brezillon@overkiz.com>
Subject: Re: [RFC PATCH 6/9] mtd: nand: add sunxi NFC dt bindings doc
Date: Thu, 9 Jan 2014 11:00:57 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com> <201401082228.55807.arnd@arndb.de> <52CE5E5A.6050209@overkiz.com>
In-Reply-To: <52CE5E5A.6050209@overkiz.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401091100.58174.arnd@arndb.de>
X-Provags-ID: V02:K0:rb5gJRBmhKO71TXMj6uB+uNlTYjQPakOxEomkZp0D3c
 HNNxI6keBt3vP6nqqs8hGwHZfzaHrHsbhSEnpJ8dmImSDCJqon
 jJlWBV1bbbrqeFSygMCaFV9tRpGi1dN9gPhFBFtaFpcPfldUnL
 eZ5D7/nmSNUP8XRbv353d88gkdXSc+R/9tMrvtbp47ZmCpDQAf
 C5IvlHXJ6O7B18JtE4qPW4HyWHAD+zWpjCM80/ObcnAyP/0r4P
 HUE7E3kBRzVpK/+qTXb7QpQxlVNsbjZG9yM9fp1Ay4VgnmLWj6
 cyfoZ01Gxx/7AmKAsTmxWj/2vCcepADiMe+LtYY0WDo5Q39y6E
 E55S9sCPBWNgDVMFbeVI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 January 2014, boris brezillon wrote:
> Sure, I'll remove references to the NFC acronym:
>   - change compatible string to "allwinner,sun4i-nand"
>   - avoid NFC references in the doc
>   - rename the driver into sunxi-nand.c (formerly sunxi_nfc.c)
> 
> Do you see any other references to this acronym ?
> 

Those are the important ones, thanks!

Regarding the binding, I would mention nfc once there to help people
that happen to look for that.

	Arnd
