Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab3BKR05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:26:57 -0500
Received: from void.printf.net ([89.145.121.20]:52393 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758257Ab3BKR0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:26:55 -0500
From: Chris Ball <cjb@laptop.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH 2/3] mmc: use regulator_can_change_voltage() instead of regulator_count_voltages() hacks
References: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
	<1354629663-29091-3-git-send-email-m.szyprowski@samsung.com>
	<510BD3B1.3040601@samsung.com>
Date: Mon, 11 Feb 2013 12:26:42 -0500
In-Reply-To: <510BD3B1.3040601@samsung.com> (Marek Szyprowski's message of
	"Fri, 01 Feb 2013 15:39:45 +0100")
Message-ID: <87fw12rcbx.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Fri, Feb 01 2013, Marek Szyprowski wrote:
> On 12/4/2012 3:01 PM, Marek Szyprowski wrote:
>> mmc_regulator_set_ocr() depends on the ability of regulator to change the
>> voltage value. When regulator cannot change its voltage output, some code is
>> skipped to avoid reporting false errors on some boards, which use MMC hosts
>> with fixed regulators (example: Samsung Goni and UniversalC210 boards).
>>
>> This patch replaces a hacky workaround based on regulator_count_voltages()
>> value with the correct call to recently introduced
>> regulator_can_change_voltage() function in regulators core.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>
> Any chance to get this patch scheduled for v3.9?

Thanks, pushed to mmc-next for 3.9.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
