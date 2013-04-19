Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030451Ab3DSNrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:47:51 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:48018 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030367Ab3DSNru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:47:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130418105246.GO14496@n2100.arm.linux.org.uk>
References: <1366281314-14613-1-git-send-email-linus.walleij@stericsson.com>
	<20130418105246.GO14496@n2100.arm.linux.org.uk>
Date: Fri, 19 Apr 2013 15:47:48 +0200
Message-ID: <CACRpkdbEuuy62h+szbyFiFkFBiHx21oSDYBMtkzWkv7PJ32+xQ@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl/pinconfig: add debug interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Laurent Meunier <laurent.meunier@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:52 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Apr 18, 2013 at 12:35:14PM +0200, Linus Walleij wrote:
>> +             if (map->type != dbg->map_type)
>> +                     continue;
>> +             if (!!strcmp(map->dev_name, dbg->dev_name))
>
> !! is pointless in this context - if() evaluates any non-zero value as
> true, so there's no point making the code more complicated by trying to
> convert it to a false/true value first.

I fixed this up and applied it since there are no further comments.

Thanks!
Linus Walleij
