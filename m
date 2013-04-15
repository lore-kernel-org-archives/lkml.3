Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3DOVdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:33:38 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35921 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab3DOVdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:33:35 -0400
From: Kevin Hilman <khilman@linaro.org>
To: "Bedia\, Vaibhav" <vaibhav.bedia@ti.com>
Cc: "Poddar\, Sourav" <sourav.poddar@ti.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tony\@atomide.com" <tony@atomide.com>,
        "rmk+kernel\@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial\@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Shilimkar\, Santosh" <santosh.shilimkar@ti.com>,
        "Balbi\, Felipe" <balbi@ti.com>, "Nayak\, Rajendra" <rnayak@ti.com>
Subject: Re: [PATCHv3] driver: serial: prevent UART console idle on suspend while using "no_console_suspend"
References: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com>
	<87mwtclvua.fsf@linaro.org> <516463D2.2070008@ti.com>
	<87obdnh6au.fsf@linaro.org> <516501A0.4000004@ti.com>
	<B5906170F1614E41A8A28DE3B8D121433ED96446@DBDE01.ent.ti.com>
	<51653450.2010200@ti.com>
	<B5906170F1614E41A8A28DE3B8D121433ED96C45@DBDE01.ent.ti.com>
	<87bo9myt52.fsf@linaro.org> <87y5cpxiey.fsf@linaro.org>
	<B5906170F1614E41A8A28DE3B8D121433EDA7A0D@DBDE01.ent.ti.com>
Date: Mon, 15 Apr 2013 14:33:32 -0700
In-Reply-To: <B5906170F1614E41A8A28DE3B8D121433EDA7A0D@DBDE01.ent.ti.com>
	(Vaibhav Bedia's message of "Mon, 15 Apr 2013 11:50:37 +0000")
Message-ID: <87haj7cwcz.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vaibhav,

"Bedia, Vaibhav" <vaibhav.bedia@ti.com> writes:

[...]

>> So, my proposal is that Sourav remove that flag from the AM33xx hwmod
>> when he removes this feature.
>
> Apologies for the delayed response. I was out of office for a couple of
> days.
>
> I don't recall the exact kernel version in which I ended up adding
> this flag to keep the clock running but yes after the change mentioned
> below this flag is not required. I just did a sanity check by removing
> this flag on v3.8 kernel and things work fine across suspend.

Great, thanks for checking. 

That leaves only the UART driver, so after Sourav's changes, we will
drop the flag completely.

Kevin
