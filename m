Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaHZQUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:20:43 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:49275 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHZQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:20:41 -0400
Date: Tue, 26 Aug 2014 17:20:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v2 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140826162031.GB26707@lee--X1>
References: <20140820092117.GI4266@lee--X1>
 <53FA9D1E.8040202@rock-chips.com>
 <20140826092205.GG9574@lee--X1>
 <53FC5BD1.7030406@rock-chips.com>
 <20140826102036.GJ9574@lee--X1>
 <53FC63EE.6060104@rock-chips.com>
 <20140826112013.GK9574@lee--X1>
 <53FC77F0.4030004@rock-chips.com>
 <20140826122304.GA26707@lee--X1>
 <53FC7F8A.2050903@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53FC7F8A.2050903@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Chris Zhong wrote:

[...]

> Well, it might be better to delete the pdata from MFD.

Bingo!  That's what I've been trying to get at.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
