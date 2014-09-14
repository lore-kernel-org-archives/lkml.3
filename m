Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaINCaA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 22:30:00 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:48785 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752283AbaINC37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 22:29:59 -0400
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <468c0db50b87cb43005c45a910d8c9a0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5414FD9E.4000602@rock-chips.com>
Date: Sun, 14 Sep 2014 10:29:50 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jianqun <jay.xu@rock-chips.com>
CC: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Subject: Re: [PATCH] ASoC: rockchip-i2s: dt: swap tx and rx channed request
 number
References: <1410570281-23681-1-git-send-email-jay.xu@rock-chips.com> <20140913164032.GN7960@sirena.org.uk>
In-Reply-To: <20140913164032.GN7960@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



在 09/14/2014 12:40 AM, Mark Brown 写道:
> On Sat, Sep 13, 2014 at 09:04:41AM +0800, Jianqun wrote:
>> Reference to RK3288 TRM, fix an error channel id for i2s tx and rx
>> Table 10-1 DMAC_BUS Request Mapping Table
>> Req number	Source	Polarity
>> 0		I2S tx	High level
>> 1		I2S rx	High level
> 
> Applied, thanks.  The changelog should've just noted that this is an
> error in the example rather than the code or the binding, I was a bit
> confused about this.
> 
ok, I will do it
