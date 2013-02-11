Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab3BKR1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:27:19 -0500
Received: from void.printf.net ([89.145.121.20]:52410 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090Ab3BKR1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:27:16 -0500
From: Chris Ball <cjb@laptop.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH 3/3] mmc: sdhci: check voltage range only on regulators aware of voltage value
References: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
	<1354629663-29091-4-git-send-email-m.szyprowski@samsung.com>
	<510BD3D7.1090302@samsung.com>
Date: Mon, 11 Feb 2013 12:27:11 -0500
In-Reply-To: <510BD3D7.1090302@samsung.com> (Marek Szyprowski's message of
	"Fri, 01 Feb 2013 15:40:23 +0100")
Message-ID: <87bobqrcb4.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Fri, Feb 01 2013, Marek Szyprowski wrote:
> On 12/4/2012 3:01 PM, Marek Szyprowski wrote:
>> Some regulators don't report any voltage values, so checking supported
>> voltage range results in disabling all SDHCI_CAN_VDD_* flags and
>> registration failure. This patch finally provides a correct fix for the
>> registration of SDHCI driver with all possible voltage regulators:
>> dummy, fixed and regulated without using regulator_count_voltages()
>> hacks.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>
> Any chance to get this patch scheduled for v3.9?

This one doesn't apply -- please could you rebase/resend?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
