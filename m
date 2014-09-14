Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaINCHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 22:07:00 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:34735 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752258AbaINCG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 22:06:59 -0400
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <f696155a88a7b319c4159f16f5e77e20>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5414F82E.9090004@rock-chips.com>
Date: Sun, 14 Sep 2014 10:06:38 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jianqun <jay.xu@rock-chips.com>
CC: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Subject: Re: [PATCH 2/5] ASoC: rockchip-i2s: fix master mode set bit error
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com> <1410568863-21723-1-git-send-email-jay.xu@rock-chips.com> <20140913163501.GH7960@sirena.org.uk>
In-Reply-To: <20140913163501.GH7960@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



在 09/14/2014 12:35 AM, Mark Brown 写道:
> On Sat, Sep 13, 2014 at 08:41:03AM +0800, Jianqun wrote:
>> Fix error format set to I2S master or slave mode.
>> Test on RK3288 board with max98090.
> 
> Applied.  Since this is a bug fix it should be one of the first patches
> in the series so that it can be sent to Linus as a fix, bug fixes should
> go before any other patches.
> 

got it, I'll do it at new version patch, thanks 
