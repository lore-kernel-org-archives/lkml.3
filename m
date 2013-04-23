Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3DWHNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:13:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51733 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865Ab3DWHNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:13:50 -0400
Message-ID: <517634A3.30104@ti.com>
Date: Tue, 23 Apr 2013 09:13:39 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130408 Thunderbird/17.0.5
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Sourav Poddar <sourav.poddar@ti.com>, <gregkh@linuxfoundation.org>,
        <tony@atomide.com>, <rmk+kernel@arm.linux.org.uk>,
        <khilman@linaro.org>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra nayak <rnayak@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [RFC/PATCHv2 5/5] arm: omap2+: omap_device: remove no_idle_on_suspend
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com> <1366638237-6880-6-git-send-email-sourav.poddar@ti.com> <20130422143839.GE7508@arwen.pp.htv.fi>
In-Reply-To: <20130422143839.GE7508@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/22/2013 04:38 PM, Felipe Balbi wrote:
>> Is it possible to handle ABE no_idle_on_suspend uscase the way I am
>> trying to handle it for UART in the 2nd patch of this series? 
> 
> let's ask Péter.
> 
> Péter, OMAP_DEVICE_NO_IDLE_ON_SUSPEND should be removed as driver's can
> get same behavior by just returning -EBUSY from their ->runtime_suspend
> callbacks. Do you see any problems with patch below (left for
> reference) ? Would it be too difficult to add
> ->runtime_suspend/->runtime_resume on ASoC layer ?

I don't see any issue with this. FWIW AESS/ABE does not use the
OMAP_DEVICE_NO_IDLE_ON_SUSPEND flag neither in upstream nor in my development
branch.

-- 
Péter
