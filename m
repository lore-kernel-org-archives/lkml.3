Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3JYMkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 08:40:41 -0400
Received: from smtp4.epfl.ch ([128.178.224.219]:59244 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab3JYMkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 08:40:39 -0400
Message-ID: <526A66C0.1040402@epfl.ch>
Date: Fri, 25 Oct 2013 14:40:32 +0200
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv6 1/3] Input: twl4030-pwrbutton - add device tree support
References: <1382626126-12565-1-git-send-email-sre@debian.org> <1382626126-12565-2-git-send-email-sre@debian.org>
In-Reply-To: <1382626126-12565-2-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/24/2013 04:48 PM, Sebastian Reichel wrote:
> Add device tree support for twl4030 power button driver.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>

I tested on my OMAP3 board, the button event works as expected. So for
the DT boot, feel free to add my:

Tested-by: Florian Vaussard <florian.vaussard@epfl.ch>

Best regards,

Florian
