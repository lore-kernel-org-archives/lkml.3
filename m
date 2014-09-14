Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaINCUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 22:20:24 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:46303 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752249AbaINCUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 22:20:23 -0400
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <54c959ecd843c95d4ca2eafd2a4230b3>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5414FB5B.8090907@rock-chips.com>
Date: Sun, 14 Sep 2014 10:20:11 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jianqun <jay.xu@rock-chips.com>
CC: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Subject: Re: [PATCH 4/5] ASoC: rockchip-i2s: fix registers' property of rockchip
 i2s controller
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com> <1410568932-21823-1-git-send-email-jay.xu@rock-chips.com> <20140913163613.GI7960@sirena.org.uk>
In-Reply-To: <20140913163613.GI7960@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



在 09/14/2014 12:36 AM, Mark Brown 写道:
> On Sat, Sep 13, 2014 at 08:42:12AM +0800, Jianqun wrote:
>> Reference rockchip I2S controller TRM, modify some registers' property
>> I2S_FIFOLR: read / write, but not volatile, not precious
>> I2S_INTSR: read / write
>> I2S_CLR: volatile, register value will be cleared by read
> 
> Applied, again this is a bug fix (volatile and precious being wrong seem
> like bugs) so should have been earlier in the series.
> 
ok, I'll re-order the patches
