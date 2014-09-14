Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaINCYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 22:24:12 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:55998 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254AbaINCYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 22:24:10 -0400
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <4efcd3c21e7e08353c2bb814d5f7f38c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5414FC40.1040005@rock-chips.com>
Date: Sun, 14 Sep 2014 10:24:00 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jianqun <jay.xu@rock-chips.com>
CC: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Subject: Re: [PATCH 5/5] ASoC: rockchip-i2s: enable "hclk" for rockchip I2S
 controller
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com> <1410568993-21874-1-git-send-email-jay.xu@rock-chips.com> <20140913163648.GJ7960@sirena.org.uk>
In-Reply-To: <20140913163648.GJ7960@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



在 09/14/2014 12:36 AM, Mark Brown 写道:
> On Sat, Sep 13, 2014 at 08:43:13AM +0800, Jianqun wrote:
>> As "hclk" is used for rockchip I2S controller, driver must to enable
>> it in probe.
> 
> Applied, again this is a bug fix.  How did the original submission get
> tested?
> 
The original submission is verified on rk3288 with kernel 3.10, but I had to make patches based on
kernel 3.14 +, also our sdk kernel has intalized the kernel in other ways, so I missed the enable but
the driver worked well.

The new patches is verified on kernel 3.14, so it will easy to test.
