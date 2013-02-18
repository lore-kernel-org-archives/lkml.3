Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3BRJNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:13:41 -0500
Received: from intranet.asianux.com ([58.214.24.6]:41530 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3BRJNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:13:39 -0500
X-Spam-Score: -100.8
Message-ID: <5121F0BA.2080103@asianux.com>
Date: Mon, 18 Feb 2013 17:13:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] drivers/gpio/*twl* need call irq_free_descs when leaving
References: <511F34C3.6020406@asianux.com> <5121EFE7.7040301@ti.com>
In-Reply-To: <5121EFE7.7040301@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月18日 17:09, Peter Ujfalusi 写道:
> On 02/16/2013 08:26 AM, Chen Gang wrote:
>> > 
>> >   since already call irq_alloc_descs before,
>> >     we need call irq_free_descs when quiting, or resource leak.
> While it is true that we need to free the descs, but this patch is not correct.
> We have other issues to fix in the driver - I have not looked at the
> probe/remove path yet, but the sequence is not right and also the call of
> gpio_twl4030_remove() from probe is not correct.
> 
> I'll send a small series to fix these up.
> 

  ok, thank you.

  :-)

-- 
Chen Gang

Asianux Corporation
