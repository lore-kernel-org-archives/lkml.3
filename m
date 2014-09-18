Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbaIRRCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:02:55 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:64368 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaIRRCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:02:53 -0400
Date: Thu, 18 Sep 2014 10:02:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, addy.ke@rock-chips.com, zyf@rock-chips.com,
        cjf@rock-chips.com, =?utf-8?B?6ZKf5YuH5rGq?= <zyw@rock-chips.com>,
        zhengsq@rock-chips.com
Subject: Re: [PATCH v5 1/4] thermal: rockchip: add driver for Thermal
Message-ID: <20140918170249.GC14809@core.coreip.homeip.net>
References: <1410926353-15674-1-git-send-email-caesar.wang@rock-chips.com>
 <1410926353-15674-2-git-send-email-caesar.wang@rock-chips.com>
 <20140917170223.GB25297@core.coreip.homeip.net>
 <541A985C.6030301@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541A985C.6030301@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

On Thu, Sep 18, 2014 at 04:31:24PM +0800, Caesar Wang wrote:
> Dear Dmitry,
> 
> 
> 在 2014年09月18日 01:02, Dmitry Torokhov 写道:
> >Hi Caesar,
> >
> >On Wed, Sep 17, 2014 at 11:59:10AM +0800, Caesar Wang wrote:
> >>+{
> >>+	int i;
> >>+
> >>+	for (i = 0; i < ARRAY_SIZE(v2_code_table) - 1; i++) {
> >>+		if (code >= v2_code_table[i].code)
> >>+			return v2_code_table[i].temp;
> >>+	}
> >>+
> >>+	return 0;
> >I think if we do not find the code we should be returning max
> >temperature, not 0.
> Agree.
> >And also WARN_ON() as this should not be happening.
> >
> Maybe,I will fix it as the follows:
> 
> pr_warn("Don't find code from v2_code_table\n");
> return 125;
> 
> Do you agree?

Sounds good.

Thanks.

-- 
Dmitry
