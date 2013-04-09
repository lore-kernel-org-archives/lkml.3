Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937087Ab3DIJgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:36:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3DIJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:36:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/5] dmaengine: ste_dma40: Do not configure channels during an channel allocation
Date: Tue, 9 Apr 2013 11:36:09 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org> <1365434591-21569-4-git-send-email-lee.jones@linaro.org> <20130409071154.GH3084@gmail.com>
In-Reply-To: <20130409071154.GH3084@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091136.09629.arnd@arndb.de>
X-Provags-ID: V02:K0:5WnAxvUSyFnlxBcSgzNki2hyZy/tN2a40uMKbiRVCpD
 RX0hqxoIwYWloYbZdMIZsisl/2b6J2tVrGZ6ovYuuxolgoCHK2
 OTzLdSCLpKpHMfH5d4qLgqPcryDGh88rcvlZs0lznHN3NSyhkz
 t4NNCMYzlwP0ix+3CeRmXud2z4WS+MTO481NkwOmlW+GE+6/vp
 N0CX2FRuakzwGuTu3a+iSiNPgIcvAwfyQAQ3Yvsdp2i8ToMHHk
 fqIuIiI/Y0EGp+XO4mLkUGIwHyrCgfBOoHTeEFNRDoIguvpGVS
 fX4IagYvUsOgXFilznDaUj9Lk8cqNq92opgXj4hZB9u6SZ1JpU
 BS+MoXARYQjKFeZaolaQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lee Jones wrote:
> According to the DMA documentation allocating a channel and configuring
> it are two separate actions. By removing the configuration code from the
> channel allocation path we lighten the burden on the information required to
> successfully allocate a channel.

Did you send out the first version again? The text is the same as before.

	Arnd
