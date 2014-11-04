Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaKDJYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:24:16 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39937 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaKDJYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:24:14 -0500
Message-ID: <54589B32.5050109@collabora.co.uk>
Date: Tue, 04 Nov 2014 10:24:02 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 0/6] regulator: max77686/802: Cleanup
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 11/04/2014 09:49 AM, Krzysztof Kozlowski wrote:
> Previously this patchset was part of adding GPIO to max77686
> regulator driver [1]. I split it but the goal is the same:
> cleanup and simplify the regulator drivers by removing obsolete
> board file support so adding new features would be easier.
> 

This series will conflict with fixes that Mark applied yesterday:

ecea748 ("regulator: max77802: zero-initialize regulator match table")
050cf85 ("regulator: max77686: zero-initialize regulator match table")

You should base on top of the regulator for-next branch.

Best regards,
Javier

